class SewingController < SharedController
  skip_before_action :verify_authenticity_token

  def new
    variables = {
      model: GarmentSewing,
      model_name: "garment_sewing",
      redirect_path: new_sewing_details_path
    }
    generic_new(variables)
  end

  def create
    @garment_sewing = GarmentSewing.new(data_hora_ida: params[:garment_sewing][:data_hora_ida], costureira_id: params[:garment_sewing][:entidade_id])
    @garment_sewing.finalizado = false
    @financial_records = []
    all_valid = true

    unless params[:valor].nil?
      params[:valor].each_with_index do |valor, index|
        tipo_movimento = 'Saída'
        observacao = params[:observacao][index]
        data_hora = @garment_sewing.data_hora_ida
        @financial_records << FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
      end
      
      @financial_records.each do |financial_record|
        unless financial_record.valid?
          all_valid = false
        end      
      end
    end

    if @garment_sewing.valid? && all_valid
      flash[:notice] = []
      @garment_sewing.save
    
      @financial_records.each do |financial_record|
        observacao_original = financial_record.observacao
        pre_msg = 'Costureira - Envio'
        pre_msg += ' - ' unless observacao_original.blank?
        financial_record.observacao = pre_msg + financial_record.observacao
        financial_record.save

        financial_garment_sewing = FinancialGarmentSewing.new(
          registro_financeiro: financial_record,
          peca_costura: @garment_sewing,
          retorno: false
        )

        if financial_garment_sewing.valid?
          financial_garment_sewing.save
          # Temp
          flash[:notice] << 'Vinculo entre movimentação de caixa e peca à costureira criado com sucesso!'
        else
          flash[:notice] << 'Erro ao criar o vinculo entre movimentação de caixa e peca à costureira!'
        end
      end
      # Temp
      if @financial_records.any?
        flash[:notice] << 'Movimentação de caixa criada com sucesso!'
      end

      flash[:notice] << 'Envio à Serigrafia criado com sucesso!'
      redirect_to new_sewing_details_path
    else
      busca_entidades
      render :new
    end
  end

  def new_details
    flash[:alert] = []
    
    unless (GarmentSewing.any? && (GarmentSewing.last.finalizado == false))
      redirect_to new_sewing_path
    else
      @peca = {
        garment_type_id: 0,
        estampada: false,
        quantidade: nil
      }

      @pecas = []
      session.delete(:pecas)
      session[:pecas] ||= []
      
      @garment_stocks_groups = GarmentStock.all.group_by { |garment_stock| [garment_stock.tipo_peca.nome, garment_stock.costurada, garment_stock.estampada] }
      @garment_stocks_groups.each do |garment_stock_group|
        last = garment_stock_group[1].last
        if last.saldo <= 0 || last.costurada?
          @garment_stocks_groups.delete(garment_stock_group[0])
        end
      end

      garment_types_estoque = @garment_stocks_groups.map { |garment_stock_group| garment_stock_group[0][0] }.uniq

      @garment_types = GarmentType.where(nome: garment_types_estoque)
    end
  end

  def create_details
    @garment_stocks_groups = GarmentStock.all.group_by { |garment_stock| [garment_stock.tipo_peca.nome, garment_stock.costurada, garment_stock.estampada] }
    @garment_stocks_groups.each do |garment_stock_group|
      last = garment_stock_group[1].last
      if last.saldo <= 0 || last.costurada?
        @garment_stocks_groups.delete(garment_stock_group[0])
      end
    end

    garment_types_estoque = @garment_stocks_groups.map { |garment_stock_group| garment_stock_group[0][0] }.uniq

    @garment_types = GarmentType.where(nome: garment_types_estoque)
   
    @pecas = []
    button = params[:commit]

    flash[:notice] = []

    if button == 'Adicionar' || button == 'Remover' || button == 'Finalizar'
      
      session[:pecas].each do |peca_session|
        peca = {
          garment_type_id: peca_session["garment_type_id"],
          estampada: peca_session["estampada"],
          quantidade: peca_session["quantidade"]
        }      
        @pecas << peca
      end

      if button == 'Adicionar'
        peca_validar = {
          garment_type_id: params[:peca][:garment_type_id],
          estampada: params[:peca][:estampada],
          quantidade: params[:peca][:quantidade].to_i
        }

        
        #flash[:notice] << params[:peca].inspect
        #flash[:notice] << peca_validar.inspect

        if validate_peca(peca_validar)
          combinacao_existe = false
          @pecas.each do |peca|
            if (peca[:garment_type_id] == peca_validar[:garment_type_id]) && (peca[:estampada] == peca_validar[:estampada])
              combinacao_existe = true
            end
          end

          unless combinacao_existe
            session[:pecas] << peca_validar
            @pecas << peca_validar
          else
            # irá apenas atualizar a quantidade
            @pecas.each do |peca|
              if (peca[:garment_type_id] == peca_validar[:garment_type_id]) && (peca[:estampada] == peca_validar[:estampada])
                peca[:quantidade] += peca_validar[:quantidade]

                session[:pecas].each do |peca_session|
                  if (peca_session["garment_type_id"] == peca_validar[:garment_type_id]) && (peca_session["estampada"] == peca_validar[:estampada])
                    peca_session["quantidade"] = peca[:quantidade]
                  end
                end
              end
            end
          end
        else
          @peca = peca_validar
        end
      elsif button == 'Remover'
        index_peca = params[:peca_index].to_i
        session[:pecas].delete_at(index_peca)
        @pecas.delete_at(index_peca)
      elsif button == 'Finalizar'
        if @pecas.any?
          # session.delete(:pecas)
          # session[:pecas] ||= []
        
          save_pecas(@pecas)

          flash[:notice] << 'Envio à Costureira finalizado com sucesso!'
          redirect_to root_path and return
        else
          flash[:alert] = 'Nenhum peca adicionado!'
        end
      end
    end

    if @peca.nil?
      @peca = {
        garment_type_id: 0,
        estampada: false,
        quantidade: nil
      }
    end

    render :new_details
  end

  def validate_peca(peca)
    #flash[:notice] = []
    
    if peca[:estampada].nil?
      peca[:estampada] = false
    else
      peca[:estampada] = true
    end

    #flash[:notice] << (peca[:estampada] == 'false')

    garment_stock = GarmentStock.new
    garment_stock.tipo_peca_id = peca[:garment_type_id]
    garment_stock.estampada = peca[:estampada]
    garment_stock.costurada = false
    garment_stock.quantidade = peca[:quantidade]
    garment_stock.tipo_movimento = 'Saída'
    garment_stock.data_hora = GarmentSewing.last.data_hora_ida    
    garment_stock[:estampada] = false if garment_stock[:estampada].nil?
    
    quantidade_original = peca[:quantidade]
    @pecas.each do |peca_session|
      if (peca_session[:garment_type_id] == peca[:garment_type_id]) && (peca_session[:estampada] == peca[:estampada])
        garment_stock.quantidade += peca_session[:quantidade].to_i unless garment_stock.quantidade <= 0
      end
    end

    validation = true

    unless garment_stock.valid?
      @garment_stock_errors = garment_stock.errors
      validation = false
    end

    garment_sewing_stock_exit = GarmentSewingStockExit.new
    garment_sewing_stock_exit.peca_costura = GarmentSewing.last
    garment_sewing_stock_exit.estoque_peca = garment_stock
    validation = false unless garment_sewing_stock_exit.valid?
    @garment_sewing_stock_exit_errors = garment_sewing_stock_exit.errors
    #flash[:notice] << @garment_sewing_stock_exit_errors.full_messages
    
    validation
  end

  def get_total_quantity_estampada
    garment_type_id = params[:garment_type_id]
    estampada = params[:estampada]
    total_quantity = GarmentStock.where(tipo_peca_id: garment_type_id, estampada: estampada, costurada: false).last
    
    unless total_quantity.nil?
      total_quantity = total_quantity[:saldo]
    else
      total_quantity = 0
    end
    
    if estampada == 'true'
      estampada = true
    else
      estampada = false
    end

    session[:pecas].each do |peca|
      if (peca["garment_type_id"] == garment_type_id) && (peca["estampada"] == estampada)
        total_quantity = total_quantity - peca["quantidade"].to_i
      end
    end

    total_quantity = 0 if total_quantity < 0

    render json: { total_quantity: total_quantity }
  end

  def save_pecas(pecas)
    flash[:notice] = []
    #flash[:notice] << tecidos.inspect
    #flash[:notice] << 'teste'
    # exemplo
    # [{:garment_type_id=>"1", :color_id=>"1", :quantidade=>1.0, :garment_type_id=>"1", :multiplicador_x=>"4.6", :rendimento=>"4.60"}, {:garment_type_id=>"2", :color_id=>"2", :quantidade=>5.0, :garment_type_id=>"1", :multiplicador_x=>"4.6", :rendimento=>"23.00"}]
    pecas.each do |peca|
      garment_stock = GarmentStock.new
      garment_stock.tipo_peca_id = peca[:garment_type_id]
      garment_stock.costurada = false
      garment_stock.estampada = peca[:estampada]
      garment_stock.quantidade = peca[:quantidade]
      garment_stock.tipo_movimento = 'Saida'
      garment_stock.data_hora = GarmentSewing.last.data_hora_ida
      garment_stock[:estampada] = false if garment_stock[:estampada].nil?
      flash[:notice] << "Saida invalida" unless garment_stock.valid?
      garment_stock.save

      garment_sewing_stock_exit = GarmentSewingStockExit.new
      garment_sewing_stock_exit.peca_costura = GarmentSewing.last
      garment_sewing_stock_exit.estoque_peca = garment_stock
      flash[:notice] << "Vinculo invalido" unless garment_sewing_stock_exit.valid?
      garment_sewing_stock_exit.save
    end

    GarmentSewing.last.update(finalizado: true)
    GarmentSewing.last.update(total_pecas_envio: pecas.sum { |peca| peca[:quantidade].to_i })
  end

  def return
    @garment_sewings = GarmentSewing.where(data_hora_volta: nil, finalizado: true)
  end

  def return_details
    flash[:notice] = []
    
    unless GarmentSewing.find(params[:id]).data_hora_volta.nil?
      flash[:notice] << 'Costura já finalizada!'
      redirect_to root_path and return
    end
    
    @garment_sizes = GarmentSize.all
    @lote_tamanhos = []
    @financial = {
      valor: nil,
      observacao: ''
    }

    @financial_extra = []
    @errors = {}

    garment_sewing = GarmentSewing.find(params[:id])
    data_hora_volta = Time.now #- 3.hour
    garment_stock_exits = GarmentSewingStockExit.where(peca_costura: garment_sewing)

    @lote = {
      peca_costura: garment_sewing,
      data_hora_volta: data_hora_volta,
      garment_stock_exits: []
    }

    garment_stock_exits.each_with_index do |garment_stock_exit, index|
      @lote_tamanhos << {}
      @lote[:garment_stock_exits] << {
        tipo_peca: garment_stock_exit.estoque_peca.tipo_peca.nome,
        estampada: garment_stock_exit.estoque_peca.estampada,
        quantidade: garment_stock_exit.estoque_peca.quantidade,
        pecas: 0,
        tamanhos: false,
      }
    end
  end

  def create_sewing_return
    @errors = {}
    #@errors[:teste] = ['teste1', 'teste2']

    all_valid = false
    flash[:notice] = []
    button = params[:commit]
    button = 'Remover' unless params[:remove_button].nil?
    #flash[:notice] << button

    @garment_sizes = GarmentSize.all
    @lote_tamanhos = []
    unless params['financial'].nil?
      @financial = {
        valor: params['financial']['valor'],
        observacao: params['financial']['obs']
      }
    else
      @financial = {
        valor: nil,
        observacao: ''
      }
    end

    # params['financial_extra'] => "financial_extra"=>{"0"=>{"valor"=>"", "obs"=>"aaaaa"}}
    @financial_extra = []
    unless params['financial_extra'].nil?
      params['financial_extra'].each do |key, value|
        @financial_extra << {
          valor: value['valor'],
          observacao: value['obs']
        }
      end
    end

    garment_sewing = GarmentSewing.find(params[:garment_sewing_id])
    data_hora_volta = params[:data_hora_volta].to_datetime
    garment_stock_exits = GarmentSewingStockExit.where(peca_costura: garment_sewing)

    @lote = {
      peca_costura: garment_sewing,
      data_hora_volta: data_hora_volta,
      garment_stock_exits: []
    }

    garment_stock_exits.each_with_index do |garment_stock_exit, index|
      unless params[:tam].nil?
        unless params[:tam]["#{index}"].nil?
          #flash[:notice] << params[:tam]["#{index}"]
          tamanhos = params[:tam]["#{index}"]
          @lote_tamanhos << tamanhos
        else
          @lote_tamanhos << {}
        end
      else
        @lote_tamanhos << {}
      end      

      tamanho = false

      unless params[:tamanhos].nil?
        tamanho = true if params[:tamanhos]["#{index}"] == 'true'
      end
    
      @lote[:garment_stock_exits] << {
        id: garment_stock_exit.id,
        tipo_peca: garment_stock_exit.estoque_peca.tipo_peca.nome,
        estampada: garment_stock_exit.estoque_peca.estampada,
        quantidade: garment_stock_exit.estoque_peca.quantidade,
        pecas: params[:pecas]["#{index}"].to_i,
        tamanho: tamanho,
      }
      #flash[:notice] << params[:pecas]["#{index}"].to_i
    end

    if button == 'Remover'
      financial_extra_index = params[:remove_button].keys.first.to_i
      @financial_extra.delete_at(financial_extra_index)
    elsif button == 'Adicionar Valor Extra'
      if financial_validate(@financial, @lote[:data_hora_volta])
        @financial_extra << @financial.clone
        @financial = {
          valor: nil,
          observacao: ''
        }
      end
    else
      all_valid = true
      all_valid = false unless financial_validate(@financial, @lote[:data_hora_volta])
      @lote[:garment_stock_exits].each_with_index do |garment_stock_exit, index|
        if garment_stock_exit[:pecas] <= 0
          all_valid = false
          @errors[:pecas] = [] if @errors[:pecas].nil?
          @errors[:pecas] << { index: index, message: 'Quantidade de peças inválida!' }
        end
      end
    end
    
    #temp
    #all_valid = false

    unless all_valid
      render :return_details and return
    else
      #flash[:notice] << "all_valid: #{all_valid}"

      # salva tudo
      # render de confirmação
      
      # 
      # @lote //
      # @lote_tamanhos //
      # @financial ///
      # @financial_extra ///
      # 

      garment_sizes = GarmentSize.all

      @lote[:garment_stock_exits].each_with_index do |garment_stock_exit, index|
        garment_type = GarmentType.where(nome: garment_stock_exit[:tipo_peca]).first
        #flash[:notice] << garment_type.inspect

        garment_stock = GarmentStock.new
        garment_stock.tipo_peca_id = garment_type.id
        garment_stock.costurada = true
        garment_stock.estampada = garment_stock_exit[:estampada]
        garment_stock.quantidade = garment_stock_exit[:pecas].to_i
        garment_stock.tipo_movimento = 'Entrada'
        garment_stock.data_hora = @lote[:data_hora_volta]
        garment_stock.valid?
        #flash[:notice] << "Index: #{index} valid: #{garment_stock.valid?}"
        #@errors[:garment_stock] = [] if @errors[:garment_stock].nil?
        #@errors[:garment_stock] << { index: index, errors: garment_stock.errors }
        #flash[:notice] << @errors.inspect
        #flash[:notice] << garment_stock.tipo_peca_id.inspect
        #flash[:notice] << fabric_stock_exit[:tipo_peca].inspect
        #flash[:notice] << GarmentType.find(garment_stock.tipo_peca_id).inspect
      
        # ativar isso
        #flash[:notice] << garment_stock.valid?
        garment_stock.save

        garment_sewing_garment = GarmentSewingGarment.new
        garment_sewing_garment.estoque_pecas = garment_stock
        garment_sewing_garment.saida_peca_estoque_costura = GarmentSewingStockExit.find(garment_stock_exit[:id])
        garment_sewing_garment.valid?
        # ativar isso
        #flash[:notice] << garment_sewing_garment.valid?
        garment_sewing_garment.save

        unless @lote_tamanhos[index].class == Hash
          @lote_tamanhos[index].each do |key, value|
            unless (value.to_i == 0)
              garment_sewing_garment_size = GarmentSewingGarmentSize.new
              garment_sewing_garment_size.peca_costura_peca = garment_sewing_garment
              garment_sewing_garment_size.tamanho = garment_sizes[key.to_i]
              garment_sewing_garment_size.qtd_tamanho = value.to_i
              garment_sewing_garment_size.valid?
              # ativar isso
              #flash[:notice] << garment_sewing_garment_size.valid?
              garment_sewing_garment_size.save
            end
          end
        end
      end

      # ativar isso
      garment_sewing.update(data_hora_volta: @lote[:data_hora_volta])
      total_pecas_retorno = @lote[:garment_stock_exits].sum { |garment_stock_exit| garment_stock_exit[:pecas].to_i }
      garment_sewing.update(total_pecas_retorno: total_pecas_retorno)

      financial_record = FinancialRecord.new
      financial_record.valor = @financial[:valor]
      financial_record.observacao = @financial[:observacao]
      #
      observacao_original = financial_record.observacao
      pre_msg = 'Costura Retorno - Custo'
      pre_msg += ' - ' unless observacao_original.blank?
      financial_record.observacao = pre_msg + financial_record.observacao
      #
      financial_record.tipo_movimento = 'Saída'
      financial_record.data_hora = @lote[:data_hora_volta]
      financial_record.valid?
      # Ativar isso
      #flash[:notice] << financial_record.valid?
      financial_record.save
      financial_garment_sewing = FinancialGarmentSewing.new
      financial_garment_sewing.registro_financeiro = financial_record
      financial_garment_sewing.peca_costura = @lote[:peca_costura]
      financial_garment_sewing.retorno = true
      financial_garment_sewing.valid?
      # Ativar isso
      #flash[:notice] << financial_garment_sewing.valid?
      financial_garment_sewing.save

      @financial_extra.each do |financial_extra|
        observacao_original = financial_extra[:observacao]
        pre_msg = 'Costura Retorno - Custo Extra'
        pre_msg += ' - ' unless observacao_original.blank?
        financial_record = FinancialRecord.new
        financial_record.valor = financial_extra[:valor]
        financial_record.observacao = pre_msg + financial_extra[:observacao]
        financial_record.tipo_movimento = 'Saída'
        financial_record.data_hora = @lote[:data_hora_volta]
        #financial_record.valid?
        # Ativar isso
        #flash[:notice] << financial_record.valid?
        financial_record.save
        financial_garment_sewing = FinancialGarmentSewing.new
        financial_garment_sewing.registro_financeiro = financial_record
        financial_garment_sewing.peca_costura = @lote[:peca_costura]
        financial_garment_sewing.retorno = true
        financial_garment_sewing.valid?
        # Ativar isso
        #flash[:notice] << financial_garment_sewing.valid?
        financial_garment_sewing.save
      end
    
      flash[:notice] << 'Retorno da Costura criado com sucesso!'
      #render :return_details and return
      redirect_to root_path and return
    end
  end

  private

  def financial_validate(financial, data_hora)
    financial_record = FinancialRecord.new(valor: financial[:valor], tipo_movimento: 'Entrada', observacao: financial[:observacao], data_hora: data_hora)
    financial_record.valid?
    #@financial_errors = financial_record.errors
    @financial_errors = financial_record.errors
    financial_record.valid?
  end

  def busca_entidades
    entity_type = EntityType.find_by(nome: 'Costureira')
    @entidades = Entity.where(entity_type: entity_type)
  end
end
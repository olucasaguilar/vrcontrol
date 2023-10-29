class FabricCutsController < ApplicationController
  def new
    if (FabricCut.any? && (FabricCut.last.finalizado == false))
      redirect_to new_fabric_cut_details_path
    else
      data_hora = Time.now - 3.hour
      busca_cortadores()
      @fabric_cut = FabricCut.new
      @fabric_cut.data_hora_ida = data_hora   
      @financial_records = []
    end
  end

  def create
    @fabric_cut = FabricCut.new(data_hora_ida: params[:fabric_cut][:data_hora_ida], cortador_id: params[:fabric_cut][:entidade_id])
    @fabric_cut.finalizado = false
    @financial_records = []
    all_valid = true

    unless params[:valor].nil?
      params[:valor].each_with_index do |valor, index|
        tipo_movimento = 'Saída'
        observacao = params[:observacao][index]
        data_hora = @fabric_cut.data_hora_ida
        @financial_records << FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
      end
      
      @financial_records.each do |financial_record|
        unless financial_record.valid?
          all_valid = false
        end      
      end
    end

    if @fabric_cut.valid? && all_valid
      flash[:notice] = []
      @fabric_cut.save
      
      @financial_records.each do |financial_record|
        observacao_original = financial_record.observacao
        pre_msg = 'Corte - Envio'
        pre_msg += ' - ' unless observacao_original.blank?
        financial_record.observacao = pre_msg + financial_record.observacao
        financial_record.save

        financial_fabric_cut = FinancialFabricCut.new(
          registro_financeiro: financial_record,
          tecido_corte: @fabric_cut,
          retorno: false
        )

        if financial_fabric_cut.valid?
          financial_fabric_cut.save
          # Temp
          flash[:notice] << 'Vinculo entre movimentação de caixa e tecido ao corte criado com sucesso!'
        else
          flash[:notice] << 'Erro ao criar o vinculo entre movimentação de caixa e tecido ao corte!'
        end
      end
      # Temp
      if @financial_records.any?
        flash[:notice] << 'Movimentação de caixa criada com sucesso!'
      end

      flash[:notice] << 'Envio ao corte criado com sucesso!'
      redirect_to new_fabric_cut_details_path
    else
      busca_cortadores()
      render :new
    end
  end

  def new_details
    unless (FabricCut.any? && (FabricCut.last.finalizado == false))
      redirect_to new_fabric_cut_path
    else
      @tecido = {
        fabric_type_id: 0,
        color_id: 0,
        quantidade: 0,
        garment_type_id: 0,
        multiplicador_x: 4.6,
        rendimento: 0
      }

      @tecidos = []
      # @fabric_stock_errors = []
      session.delete(:tecidos)
      session[:tecidos] ||= []
      
      @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
      @fabric_stock_groups.each do |fabric_stock_group|
        last_saldo = fabric_stock_group[1].last.saldo
        if last_saldo <= 0
          @fabric_stock_groups.delete(fabric_stock_group[0])
        end
      end

      colors_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
      fabric_types_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][0] }.uniq

      @fabric_types = FabricType.where(nome: fabric_types_estoque)
      @colors = Color.where(nome: colors_estoque)
      @garment_types = GarmentType.all      
    end
  end

  def quantity_to_float(quantity)
    # "15,66" => 15.66
    quantity = quantity.gsub(',', '.')
    quantity.to_f
  end

  def create_details
    @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    @fabric_stock_groups.each do |fabric_stock_group|
      last_saldo = fabric_stock_group[1].last.saldo
      if last_saldo <= 0
        @fabric_stock_groups.delete(fabric_stock_group[0])
      end
    end

    colors_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
    fabric_types_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][0] }.uniq

    @fabric_types = FabricType.where(nome: fabric_types_estoque)
    @colors = Color.where(nome: colors_estoque)
    @garment_types = GarmentType.all      

    @tecidos = []
    button = params[:commit]
    flash[:notice] = []
    #flash[:notice] = params[:commit]

    if button == 'Adicionar' || button == 'Remover' || button == 'Finalizar'
      session[:tecidos].each do |tecido_session|
        tecido = {
          fabric_type_id: tecido_session["fabric_type_id"],
          color_id: tecido_session["color_id"],
          quantidade: tecido_session["quantidade"],
          garment_type_id: tecido_session["garment_type_id"],
          multiplicador_x: tecido_session["multiplicador_x"],
          rendimento: tecido_session["rendimento"]
        }      
        @tecidos << tecido
      end

      if button == 'Adicionar'
        tecido_validar = {
          fabric_type_id: params[:tecido][:fabric_type_id],
          color_id: params[:tecido][:color_id],
          quantidade: params[:tecido][:quantidade],
          garment_type_id: params[:tecido][:garment_type_id],
          multiplicador_x: params[:tecido][:multiplicador_x],
          rendimento: params[:tecido][:rendimento]
        }

        tecido_validar[:quantidade] = quantity_to_float(tecido_validar[:quantidade])

        if validate_tecido(tecido_validar)
          combinacao_existe = false
          @tecidos.each do |tecido|
            if (tecido[:fabric_type_id] == tecido_validar[:fabric_type_id]) && (tecido[:color_id] == tecido_validar[:color_id]) && (tecido[:garment_type_id] == tecido_validar[:garment_type_id])
              combinacao_existe = true
            end
          end

          unless combinacao_existe
            session[:tecidos] << tecido_validar
            @tecidos << tecido_validar
          else
            # irá apenas atualizar a quantidade
            @tecidos.each do |tecido|
              if (tecido[:fabric_type_id] == tecido_validar[:fabric_type_id]) && (tecido[:color_id] == tecido_validar[:color_id]) && (tecido[:garment_type_id] == tecido_validar[:garment_type_id])
                tecido[:quantidade] += tecido_validar[:quantidade]
                tecido[:rendimento] = (tecido[:rendimento].to_f + tecido_validar[:rendimento].to_f).round(2)

                session[:tecidos].each do |tecido_session|
                  if (tecido_session["fabric_type_id"] == tecido_validar[:fabric_type_id]) && (tecido_session["color_id"] == tecido_validar[:color_id]) && (tecido_session["garment_type_id"] == tecido_validar[:garment_type_id])
                    tecido_session["quantidade"] = tecido[:quantidade]
                    tecido_session["rendimento"] = tecido[:rendimento]
                  end
                end
              end
            end
          end
        else
          @tecido = tecido_validar
        end
      elsif button == 'Remover'
        index_tecido = params[:tecido_index].to_i
        session[:tecidos].delete_at(index_tecido)
        @tecidos.delete_at(index_tecido)
      elsif button == 'Finalizar'
        if @tecidos.any?
          # session.delete(:tecidos)
          # session[:tecidos] ||= []
          save_tecidos(@tecidos)
          flash[:notice] << 'Envio ao corte finalizado com sucesso!'
          redirect_to root_path and return
        else
          flash[:alert] = 'Nenhum tecido adicionado!'
        end
      end
    end

    if @tecido.nil?
      @tecido = {
        fabric_type_id: 0,
        color_id: 0,
        quantidade: 0,
        garment_type_id: 0,
        multiplicador_x: 4.6,
        rendimento: 0
      }
    end

    render :new_details
    #redirect_to new_fabric_cut_details_path
  end

  def save_tecidos(tecidos)
    flash[:notice] = []
    #flash[:notice] << tecidos.inspect
    #flash[:notice] << 'teste'
    # exemplo
    # [{:fabric_type_id=>"1", :color_id=>"1", :quantidade=>1.0, :garment_type_id=>"1", :multiplicador_x=>"4.6", :rendimento=>"4.60"}, {:fabric_type_id=>"2", :color_id=>"2", :quantidade=>5.0, :garment_type_id=>"1", :multiplicador_x=>"4.6", :rendimento=>"23.00"}]
    tecidos.each do |tecido|
      fabric_stock = FabricStock.new
      fabric_stock.tipo_tecido_id = tecido[:fabric_type_id]
      fabric_stock.cor_id = tecido[:color_id]
      fabric_stock.quantidade = tecido[:quantidade]
      fabric_stock.tipo_movimento = 'Saida'
      fabric_stock.data_hora = FabricCut.last.data_hora_ida
      flash[:notice] << "Saida invalida" unless fabric_stock.valid?
      fabric_stock.save

      fabric_stock_exit = FabricStockExit.new
      fabric_stock_exit.tecido_corte = FabricCut.last
      fabric_stock_exit.estoque_tecido = fabric_stock
      fabric_stock_exit.multiplicador = tecido[:multiplicador_x]
      fabric_stock_exit.rendimento = tecido[:rendimento]
      fabric_stock_exit.tipo_peca_id = tecido[:garment_type_id]
      flash[:notice] << "Vinculo invalido" unless fabric_stock_exit.valid?
      fabric_stock_exit.save
    end

    FabricCut.last.update(finalizado: true)
    FabricCut.last.update(total_tecido_envio: tecidos.sum { |tecido| tecido[:quantidade].to_f })
  end

  def get_colors_for_fabric_type    
    session.delete(:color_id)
    session[:color_id] ||= []

    fabric_type_id = params[:fabric_type_id]

    fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    fabric_stock_groups.each do |fabric_stock_group|
      last_saldo = fabric_stock_group[1].last.saldo
      if last_saldo <= 0
        fabric_stock_groups.delete(fabric_stock_group[0])
      end
      if fabric_stock_group[0][0] != FabricType.find(fabric_type_id).nome
        fabric_stock_groups.delete(fabric_stock_group[0])
      end
    end

    colors_estoque = fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
    colors = Color.where(nome: colors_estoque)
    colors = colors.map { |color| { id: color.id, nome: color.nome } }
    colors = colors.uniq { |color| color[:id] }

    session.delete(:fabric_type_id)
    session[:fabric_type_id] ||= []
    session[:fabric_type_id] << fabric_type_id

    render json: { colors: colors }
  end

  def get_total_quantity_for_color
    color_id = params[:color_id]
    fabric_type_id = session[:fabric_type_id].last
    total_quantity = FabricStock.where(tipo_tecido_id: fabric_type_id, cor_id: color_id).last
    render json: { total_quantity: total_quantity.saldo }
  end

  def validate_tecido(tecido)
    fabric_stock = FabricStock.new

    fabric_stock.tipo_tecido_id = tecido[:fabric_type_id]
    fabric_stock.cor_id = tecido[:color_id]
    fabric_stock.quantidade = tecido[:quantidade]
    fabric_stock.tipo_movimento = 'Saida'
    fabric_stock.data_hora = FabricCut.last.data_hora_ida
    flash[:notice] = []
    flash[:alert] = []
    
    quantidade_original = tecido[:quantidade]
    @tecidos.each do |tecido_session|
      if (tecido_session[:fabric_type_id] == tecido[:fabric_type_id]) && (tecido_session[:color_id] == tecido[:color_id])
        fabric_stock.quantidade += tecido_session[:quantidade] unless fabric_stock.quantidade <= 0
      end
    end

    validation = true

    unless fabric_stock.valid?
      @fabric_stock_errors = fabric_stock.errors
      validation = false
    end

    fabric_stock_exit = FabricStockExit.new
    fabric_stock_exit.tecido_corte = FabricCut.last
    fabric_stock_exit.estoque_tecido = fabric_stock
    fabric_stock_exit.tipo_peca_id = tecido[:garment_type_id]    
    validation = false unless fabric_stock_exit.valid?
    @fabric_stock_exit_errors = fabric_stock_exit.errors
    #flash[:notice] << @fabric_stock_exit_errors.full_messages

    unless validation
      session.delete(:color_id)
      session[:color_id] ||= []
      session[:color_id] << tecido[:color_id]
    end
    
    validation
  end

  def return
    @fabric_cuts = FabricCut.where(data_hora_volta: nil)
  end

  def return_details
    flash[:notice] = []
    
    unless FabricCut.find(params[:id]).data_hora_volta.nil?
      flash[:notice] << 'Corte já finalizado!'
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

    fabric_cut = FabricCut.find(params[:id])
    data_hora_volta = Time.now #- 3.hour
    fabric_stock_exits = FabricStockExit.where(tecido_corte: fabric_cut)

    @lote = {
      tecido_corte: fabric_cut,
      data_hora_volta: data_hora_volta,
      fabric_stock_exits: []
    }

    fabric_stock_exits.each_with_index do |fabric_stock_exit, index|
      @lote_tamanhos << {}
      @lote[:fabric_stock_exits] << {
        tipo_tecido: fabric_stock_exit.estoque_tecido.tipo_tecido.nome,
        cor: fabric_stock_exit.estoque_tecido.cor.nome,
        quantidade: fabric_stock_exit.estoque_tecido.quantidade,
        tipo_peca: fabric_stock_exit.tipo_peca.nome,
        pecas: 0,
        tamanhos: false,
      }
    end
  end

  def create_fabric_cut_return
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

    fabric_cut = FabricCut.find(params[:fabric_cut_id])
    data_hora_volta = params[:data_hora_volta].to_datetime
    fabric_stock_exits = FabricStockExit.where(tecido_corte: fabric_cut)

    @lote = {
      tecido_corte: fabric_cut,
      data_hora_volta: data_hora_volta,
      fabric_stock_exits: []
    }

    fabric_stock_exits.each_with_index do |fabric_stock_exit, index|
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
      
      @lote[:fabric_stock_exits] << {
        id: fabric_stock_exit.id,
        tipo_tecido: fabric_stock_exit.estoque_tecido.tipo_tecido.nome,
        cor: fabric_stock_exit.estoque_tecido.cor.nome,
        quantidade: fabric_stock_exit.estoque_tecido.quantidade,
        tipo_peca: fabric_stock_exit.tipo_peca.nome,
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
      @lote[:fabric_stock_exits].each_with_index do |fabric_stock_exit, index|
        if fabric_stock_exit[:pecas] <= 0
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

      # GarmentStock
      # *tipo_peca (FK) INT GarmentType
      # *costurada BOOLEAN
      # *estampada BOOLEAN
      # *quantidade INT
      # *tipo_movimento VARCHAR
      # *data_hora DATETIME
      # *saldo INT

      garment_sizes = GarmentSize.all

      @lote[:fabric_stock_exits].each_with_index do |fabric_stock_exit, index|
        garment_type = GarmentType.where(nome: fabric_stock_exit[:tipo_peca]).first
        #flash[:notice] << garment_type.inspect

        garment_stock = GarmentStock.new
        garment_stock.tipo_peca_id = garment_type.id
        garment_stock.costurada = false
        garment_stock.estampada = false
        garment_stock.quantidade = fabric_stock_exit[:pecas].to_i
        garment_stock.tipo_movimento = 'Entrada'
        garment_stock.data_hora = @lote[:data_hora_volta]
        garment_stock.valid?
        #flash[:notice] << "Index: #{index} valid: #{garment_stock.valid?}"
        @errors[:garment_stock] = [] if @errors[:garment_stock].nil?
        @errors[:garment_stock] << { index: index, errors: garment_stock.errors }
        #flash[:notice] << @errors.inspect
        #flash[:notice] << garment_stock.tipo_peca_id.inspect
        #flash[:notice] << fabric_stock_exit[:tipo_peca].inspect
        #flash[:notice] << GarmentType.find(garment_stock.tipo_peca_id).inspect
        
        # ativar isso
        garment_stock.save

        fabric_cut_garment = FabricCutGarment.new
        fabric_cut_garment.estoque_pecas = garment_stock
        fabric_cut_garment.saida_tecido_estoque = FabricStockExit.find(fabric_stock_exit[:id])
        fabric_cut_garment.valid?
        # ativar isso
        fabric_cut_garment.save

        unless @lote_tamanhos[index].class == Hash
          @lote_tamanhos[index].each do |key, value|
            unless (value.to_i == 0)
              fabric_cut_garment_size = FabricCutGarmentSize.new
              fabric_cut_garment_size.tecido_corte_peca = fabric_cut_garment
              fabric_cut_garment_size.tamanho = garment_sizes[key.to_i]
              fabric_cut_garment_size.qtd_tamanho = value.to_i
              fabric_cut_garment_size.valid?
              # ativar isso
              fabric_cut_garment_size.save
            end
          end
        end
      end

      # ativar isso
      fabric_cut.update(data_hora_volta: @lote[:data_hora_volta])
      total_peca_retorno = @lote[:fabric_stock_exits].sum { |fabric_stock_exit| fabric_stock_exit[:pecas].to_i }
      fabric_cut.update(total_peca_retorno: total_peca_retorno)

      financial_record = FinancialRecord.new
      financial_record.valor = @financial[:valor]
      financial_record.observacao = @financial[:observacao]
      #
      observacao_original = financial_record.observacao
      pre_msg = 'Corte Retorno - Custo'
      pre_msg += ' - ' unless observacao_original.blank?
      financial_record.observacao = pre_msg + financial_record.observacao
      #
      financial_record.tipo_movimento = 'Saída'
      financial_record.data_hora = @lote[:data_hora_volta]
      financial_record.valid?
      # Ativar isso
      financial_record.save
      financial_fabric_cut = FinancialFabricCut.new
      financial_fabric_cut.registro_financeiro = financial_record
      financial_fabric_cut.tecido_corte = @lote[:tecido_corte]
      financial_fabric_cut.retorno = true
      financial_fabric_cut.valid?
      # Ativar isso
      financial_fabric_cut.save

      @financial_extra.each do |financial_extra|
        observacao_original = financial_extra[:observacao]
        pre_msg = 'Corte Retorno - Custo Extra'
        pre_msg += ' - ' unless observacao_original.blank?
        financial_record = FinancialRecord.new
        financial_record.valor = financial_extra[:valor]
        financial_record.observacao = pre_msg + financial_extra[:observacao]
        financial_record.tipo_movimento = 'Saída'
        financial_record.data_hora = @lote[:data_hora_volta]
        financial_record.valid?
        # Ativar isso
        financial_record.save
        financial_fabric_cut = FinancialFabricCut.new
        financial_fabric_cut.registro_financeiro = financial_record
        financial_fabric_cut.tecido_corte = @lote[:tecido_corte]
        financial_fabric_cut.retorno = true
        financial_fabric_cut.valid?
        # Ativar isso
        financial_fabric_cut.save
      end
    
      flash[:notice] << 'Retorno do corte criado com sucesso!'
      redirect_to root_path and return
    end
  end

  def financial_validate(financial, data_hora)
    financial_record = FinancialRecord.new(valor: financial[:valor], tipo_movimento: 'Entrada', observacao: financial[:observacao], data_hora: data_hora)
    financial_record.valid?
    #@financial_errors = financial_record.errors
    @financial_errors = financial_record.errors
    financial_record.valid?
  end

  private

  def busca_cortadores
    entity_type_cortador = EntityType.find_by(nome: 'Cortador')
    @cortadores = Entity.where(entity_type: entity_type_cortador)
  end
end

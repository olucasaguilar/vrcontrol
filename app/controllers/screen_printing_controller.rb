class ScreenPrintingController < SharedController
  def new
    variables = {
      model: GarmentScreenPrinting,
      model_name: "garment_screen_printing",
      redirect_path: new_screen_printing_details_path
    }
    generic_new(variables)
  end

  def create
    @garment_screen_printing = GarmentScreenPrinting.new(data_hora_ida: params[:garment_screen_printing][:data_hora_ida], serigrafia_id: params[:garment_screen_printing][:entidade_id])
    @garment_screen_printing.finalizado = false
    @financial_records = []
    all_valid = true

    unless params[:valor].nil?
      params[:valor].each_with_index do |valor, index|
        tipo_movimento = 'Saída'
        observacao = params[:observacao][index]
        data_hora = @garment_screen_printing.data_hora_ida
        @financial_records << FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
      end
      
      @financial_records.each do |financial_record|
        unless financial_record.valid?
          all_valid = false
        end      
      end
    end

    if @garment_screen_printing.valid? && all_valid
      flash[:notice] = []
      @garment_screen_printing.save
      
      @financial_records.each do |financial_record|
        observacao_original = financial_record.observacao
        pre_msg = 'Serigrafia - Envio'
        pre_msg += ' - ' unless observacao_original.blank?
        financial_record.observacao = pre_msg + financial_record.observacao
        financial_record.save

        financial_garment_screens = FinancialScreensPrinting.new(
          registro_financeiro: financial_record,
          peca_serigrafia: @garment_screen_printing,
          retorno: false
        )

        if financial_garment_screens.valid?
          financial_garment_screens.save
          # Temp
          flash[:notice] << 'Vinculo entre movimentação de caixa e peca à serigrafia criado com sucesso!'
        else
          flash[:notice] << 'Erro ao criar o vinculo entre movimentação de caixa e peca à serigrafia!'
        end
      end
      # Temp
      if @financial_records.any?
        flash[:notice] << 'Movimentação de caixa criada com sucesso!'
      end

      flash[:notice] << 'Envio à Serigrafia criado com sucesso!'
      redirect_to new_screen_printing_details_path
    else
      busca_entidades
      render :new
    end
  end

  def new_details
    unless (GarmentScreenPrinting.any? && (GarmentScreenPrinting.last.finalizado == false))
      redirect_to new_screen_printing_path
    else
      @peca = {
        garment_type_id: 0,
        costurada: false,
        quantidade: nil
      }

      @pecas = []
      session.delete(:pecas)
      session[:pecas] ||= []
      
      @garment_stocks_groups = GarmentStock.all.group_by { |garment_stock| [garment_stock.tipo_peca.nome, garment_stock.costurada, garment_stock.estampada] }
      @garment_stocks_groups.each do |garment_stock_group|
        last_saldo = garment_stock_group[1].last.saldo
        if last_saldo <= 0
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
      last_saldo = garment_stock_group[1].last.saldo
      if last_saldo <= 0
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
          costurada: peca_session["costurada"],
          quantidade: peca_session["quantidade"]
        }      
        @pecas << peca
      end

      if button == 'Adicionar'
        peca_validar = {
          garment_type_id: params[:peca][:garment_type_id],
          costurada: params[:peca][:costurada],
          quantidade: params[:peca][:quantidade].to_i
        }

        
        #flash[:notice] << params[:peca].inspect
        #flash[:notice] << peca_validar.inspect

        if validate_peca(peca_validar)
          combinacao_existe = false
          @pecas.each do |peca|
            if (peca[:garment_type_id] == peca_validar[:garment_type_id]) && (peca[:costurada] == peca_validar[:costurada])
              combinacao_existe = true
            end
          end

          unless combinacao_existe
            session[:pecas] << peca_validar
            @pecas << peca_validar
          else
            # irá apenas atualizar a quantidade
            @pecas.each do |peca|
              if (peca[:garment_type_id] == peca_validar[:garment_type_id]) && (peca[:costurada] == peca_validar[:costurada])
                peca[:quantidade] += peca_validar[:quantidade]

                session[:pecas].each do |peca_session|
                  if (peca_session["garment_type_id"] == peca_validar[:garment_type_id]) && (peca_session["costurada"] == peca_validar[:costurada])
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

          flash[:notice] << 'Envio à Serigrafia finalizado com sucesso!'
          redirect_to root_path and return
        else
          flash[:alert] = 'Nenhum peca adicionado!'
        end
      end
    end

    if @peca.nil?
      @peca = {
        garment_type_id: 0,
        costurada: false,
        quantidade: nil
      }
    end

    render :new_details
  end

  def validate_peca(peca)
    #flash[:notice] = []
    
    if peca[:costurada].nil?
      peca[:costurada] = false
    else
      peca[:costurada] = true
    end

    #flash[:notice] << (peca[:costurada] == 'false')

    garment_stock = GarmentStock.new
    garment_stock.tipo_peca_id = peca[:garment_type_id]
    garment_stock.costurada = peca[:costurada]
    garment_stock.estampada = false
    garment_stock.quantidade = peca[:quantidade]
    garment_stock.tipo_movimento = 'Saída'
    garment_stock.data_hora = GarmentScreenPrinting.last.data_hora_ida    
    garment_stock[:costurada] = false if garment_stock[:costurada].nil?
    
    quantidade_original = peca[:quantidade]
    @pecas.each do |peca_session|
      if (peca_session[:garment_type_id] == peca[:garment_type_id]) && (peca_session[:costurada] == peca[:costurada])
        garment_stock.quantidade += peca_session[:quantidade].to_i unless garment_stock.quantidade <= 0
      end
    end

    validation = true

    unless garment_stock.valid?
      @garment_stock_errors = garment_stock.errors
      validation = false
    end

    garment_screen_printing_stock_exit = GarmentScreenPrintingStockExit.new
    garment_screen_printing_stock_exit.peca_serigrafia = GarmentScreenPrinting.last
    garment_screen_printing_stock_exit.estoque_peca = garment_stock
    validation = false unless garment_screen_printing_stock_exit.valid?
    @garment_screen_printing_stock_exit_errors = garment_screen_printing_stock_exit.errors
    #flash[:notice] << @garment_screen_printing_stock_exit_errors.full_messages
    
    validation
  end

  def get_total_quantity_costurada
    garment_type_id = params[:garment_type_id]
    costurada = params[:costurada]
    total_quantity = GarmentStock.where(tipo_peca_id: garment_type_id, costurada: costurada).last
    
    unless total_quantity.nil?
      total_quantity = total_quantity[:saldo]
    else
      total_quantity = 0
    end

    if costurada == 'true'
      costurada = true
    else
      costurada = false
    end

    session[:pecas].each do |peca|
      if (peca["garment_type_id"] == garment_type_id) && (peca["costurada"] == costurada)
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
      garment_stock.costurada = peca[:costurada]
      garment_stock.estampada = false
      garment_stock.quantidade = peca[:quantidade]
      garment_stock.tipo_movimento = 'Saida'
      garment_stock.data_hora = GarmentScreenPrinting.last.data_hora_ida
      garment_stock[:costurada] = false if garment_stock[:costurada].nil?
      flash[:notice] << "Saida invalida" unless garment_stock.valid?
      garment_stock.save

      garment_screen_printing_stock_exit = GarmentScreenPrintingStockExit.new
      garment_screen_printing_stock_exit.peca_serigrafia = GarmentScreenPrinting.last
      garment_screen_printing_stock_exit.estoque_peca = garment_stock
      flash[:notice] << "Vinculo invalido" unless garment_screen_printing_stock_exit.valid?
      garment_screen_printing_stock_exit.save
    end

    GarmentScreenPrinting.last.update(finalizado: true)
    GarmentScreenPrinting.last.update(total_pecas_envio: pecas.sum { |peca| peca[:quantidade].to_i })
  end

  def return
    #
  end

  def return_details
    #
  end

  def create_screen_printing_return
    #
  end

  private

  def busca_entidades
    entity_type = EntityType.find_by(nome: 'Serigrafia')
    @entidades = Entity.where(entity_type: entity_type)
  end
end

# get '/serigrafia/envio', to: 'screen_printing#new', as: 'new_screen_printing'
# post '/serigrafia/envio', to: 'screen_printing#create', as: 'create_screen_printing'

# get '/serigrafia/envio/detalhes', to: 'screen_printing#new_details', as: 'new_screen_printing_details'
# post '/serigrafia/envio/detalhes', to: 'screen_printing#create_details', as: 'create_screen_printing_details'

# get '/serigrafia/retorno', to: 'screen_printing#return', as: 'return_screen_printing'

# get '/serigrafia/retorno/:id', to: 'screen_printing#return_details', as: 'return_screen_printing_details'
# post '/serigrafia/retorno', to: 'screen_printing#create_screen_printing_return', as: 'create_screen_printing_return'
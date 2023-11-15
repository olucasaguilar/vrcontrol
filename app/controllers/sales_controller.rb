class SalesController < SharedController
  def new
    session.delete(:pecas)
    session[:pecas] ||= []

    set_garment_types
    set_entities('Vendedor')

    @peca = {
      'garment_type_id' => nil,
      'quantidade' => nil
    }

    @garment_sale_exit = GarmentSaleExit.new
    @garment_sale_exit.data_hora = Time.now
  end

  def create
    set_garment_types
    set_entities('Vendedor')

    garment_type_id = params.dig(:peca, :garment_type_id)
    quantidade = params.dig(:peca, :quantidade)

    garment_type_id ||= nil
    quantidade ||= nil


    @peca = {
      garment_type_id: garment_type_id,
      quantidade: quantidade
    }

    flash[:notice] = []
    flash[:alert] = []

    @garment_sale_exit = GarmentSaleExit.new
    @garment_sale_exit.data_hora = params[:data_hora]
    @garment_sale_exit.vendedor_id = params[:vendedor_id]

    if params[:data_hora].nil?
      @garment_sale_exit.data_hora = session[:data_hora]
    else
      session[:data_hora] = params[:data_hora]
    end

    if params[:vendedor_id].nil?
      @garment_sale_exit.vendedor_id = session[:vendedor_id]
    else
      session[:vendedor_id] = params[:vendedor_id]
    end

    
    if params[:commit] == 'Adicionar'
      @garment_finished_stock = GarmentFinishedStock.new
      @garment_finished_stock.tipo_peca_id = @peca[:garment_type_id]
      @garment_finished_stock.quantidade = @peca[:quantidade]
      @garment_finished_stock.tipo_movimento = 'Saída'
      @garment_finished_stock.data_hora = params[:data_hora]

      if session[:pecas].any? { |p| p['garment_type_id'] == @garment_finished_stock.tipo_peca_id.to_s }
        p = session[:pecas].find { |p| p['garment_type_id'] == @garment_finished_stock.tipo_peca_id.to_s }
        @garment_finished_stock.quantidade = @garment_finished_stock.quantidade.to_i + p['quantidade'].to_i
      end

      if @garment_finished_stock.valid?
        peca = {
          'garment_type_id' => @peca[:garment_type_id],
          'quantidade' => @peca[:quantidade]
        }

        if session[:pecas].any? { |p| p['garment_type_id'] == peca['garment_type_id'] }
          p = session[:pecas].find { |p| p['garment_type_id'] == peca['garment_type_id'] }
          p['quantidade'] = p['quantidade'].to_i + peca['quantidade'].to_i
        else          
          session[:pecas] << peca
        end

        @peca[:garment_type_id] = nil
        @peca[:quantidade] = nil
      end
    end

    if params[:commit] == 'Remover'
      session[:pecas].delete_at(params[:peca_index].to_i)
    end

    if params[:commit] == 'Finalizar'
      if session[:pecas].empty?
        flash[:notice] << 'É necessário adicionar pelo menos uma peça para finalizar!'
        render :new
        return
      end
      @garment_sale_exit.save
      session[:pecas].each do |peca|
        garment_finished_stock = GarmentFinishedStock.new
        garment_finished_stock.tipo_peca_id = peca['garment_type_id']
        garment_finished_stock.quantidade = peca['quantidade']
        garment_finished_stock.tipo_movimento = 'Saída'
        garment_finished_stock.data_hora = params[:data_hora]
        garment_finished_stock.save
        garment_sale_stock_exit = GarmentSaleStockExit.new
        garment_sale_stock_exit.peca_venda_saida = @garment_sale_exit
        garment_sale_stock_exit.estoque_pecas_acabadas = @garment_finished_stock
        garment_sale_stock_exit.save
      end
      flash[:notice] << 'Saida para venda criada com sucesso!'
      redirect_to root_path
      return
    end

    render :new
  end

  def return
    session.delete(:pecas)
    session.delete(:financial_extra)
    session[:pecas] ||= []
    session[:financial_extra] ||= []

    @garment_types = GarmentType.all
    set_entities('Vendedor')

    @peca = {
      'garment_type_id' => nil,
      'quantidade' => nil
    }

    @financial = {
      'valor' => nil,
      'observacao' => nil
    }

    @garment_sale_return = GarmentSaleReturn.new
    @garment_sale_return.data_hora = Time.now
    @garment_sale_return.vendedor_id = nil
  end

  def create_return
    flash[:alert] = []
    
    @garment_types = GarmentType.all
    set_entities('Vendedor')

    garment_type_id = params.dig(:peca, :garment_type_id)
    quantidade = params.dig(:peca, :quantidade)

    garment_type_id ||= nil
    quantidade ||= nil

    @peca = {
      garment_type_id: garment_type_id,
      quantidade: quantidade
    }

    financial_valor = params.dig(:financial, :valor)
    financial_observacao = params.dig(:financial, :obs)

    financial_valor ||= nil
    financial_observacao ||= nil

    financial_valor = financial_valor.delete("^0-9,").tr(',', '.').to_f if !financial_valor.nil?
    
    @financial = {
      valor: financial_valor,
      observacao: financial_observacao
    }

    flash[:notice] = []

    @garment_sale_return = GarmentSaleReturn.new
    @garment_sale_return.data_hora = params[:data_hora]
    @garment_sale_return.vendedor_id = params[:vendedor_id]

    if params[:data_hora].nil?
      @garment_sale_return.data_hora = session[:data_hora]
    else
      session[:data_hora] = params[:data_hora]
    end

    if params[:vendedor_id].nil?
      @garment_sale_return.vendedor_id = session[:vendedor_id]
    else
      session[:vendedor_id] = params[:vendedor_id]
    end

    #flash[:notice] << params

    if params[:commit] == 'Adicionar'
      @garment_finished_stock = GarmentFinishedStock.new
      @garment_finished_stock.tipo_peca_id = @peca[:garment_type_id]
      @garment_finished_stock.quantidade = @peca[:quantidade]
      @garment_finished_stock.tipo_movimento = 'Entrada'
      @garment_finished_stock.data_hora = params[:data_hora]

      if session[:pecas].any? { |p| p['garment_type_id'] == @garment_finished_stock.tipo_peca_id.to_s }
        p = session[:pecas].find { |p| p['garment_type_id'] == @garment_finished_stock.tipo_peca_id.to_s }
        @garment_finished_stock.quantidade = @garment_finished_stock.quantidade.to_i + p['quantidade'].to_i
      end

      if @garment_finished_stock.valid?
        peca = {
          'garment_type_id' => @peca[:garment_type_id],
          'quantidade' => @peca[:quantidade]
        }

        if session[:pecas].any? { |p| p['garment_type_id'] == peca['garment_type_id'] }
          p = session[:pecas].find { |p| p['garment_type_id'] == peca['garment_type_id'] }
          p['quantidade'] = p['quantidade'].to_i + peca['quantidade'].to_i
        else          
          session[:pecas] << peca
        end

        @peca[:garment_type_id] = nil
        @peca[:quantidade] = nil
      end
    end

    if params[:commit] == 'Remover'
      session[:pecas].delete_at(params[:peca_index].to_i)
    end

    if params[:commit] == 'Adicionar Valor Extra'
      financial_extra = {
        'valor' => @financial[:valor],
        'observacao' => @financial[:observacao]
      }

      #flash[:notice] << financial_extra['valor'].class

      if financial_validate(financial_extra, params[:data_hora])
        session[:financial_extra] << financial_extra

        @financial[:valor] = nil
        @financial[:observacao] = nil

        flash[:notice] << 'Valor extra adicionado com sucesso!'
      end
    end

    if params[:remove_button].present?
      index = params[:remove_button].keys[0].to_i
      session[:financial_extra].delete_at(index)
    end
      

    if params[:commit] == 'Finalizar'
      #flash[:notice] << 'Finalizar clidado'
      all_valid = true
      
      unless (@financial[:valor].to_s == '0.0')
        financial = {
          'valor' => @financial[:valor],
          'observacao' => @financial[:observacao]
        }
        all_valid = false if !financial_validate(financial, params[:data_hora])
      end

      if session[:pecas].empty? && session[:financial_extra].empty? && (@financial[:valor].to_s == '0.0')
        flash[:alert] << 'É necessário adicionar pelo menos uma peça ou um valor para finalizar!'
        render :return
        return
      end

      if all_valid
        @garment_sale_return.save
        #flash[:notice] << @garment_sale_return.valid?

        session[:pecas].each do |peca|
          garment_finished_stock = GarmentFinishedStock.new
          garment_finished_stock.tipo_peca_id = peca['garment_type_id']
          garment_finished_stock.quantidade = peca['quantidade']
          garment_finished_stock.tipo_movimento = 'Entrada'
          garment_finished_stock.data_hora = params[:data_hora]
          garment_finished_stock.save
          #flash[:notice] << garment_finished_stock.valid?
          garment_sale_stock_return = GarmentStockEntry.new
          garment_sale_stock_return.peca_venda_retorno = @garment_sale_return
          garment_sale_stock_return.saida_peca_acabada = garment_finished_stock
          garment_sale_stock_return.save
          #flash[:notice] << garment_sale_stock_return.valid?
        end

        session[:financial_extra].each do |financial|
          financial_record = FinancialRecord.new(valor: financial['valor'], tipo_movimento: 'Saída', observacao: financial['observacao'], data_hora: params[:data_hora])
          #
          observacao_original = financial_record.observacao
          pre_msg = 'Venda Retorno'
          pre_msg += ' - ' unless observacao_original.blank?
          financial_record.observacao = pre_msg + financial_record.observacao
          #
          financial_record.save
          #flash[:notice] << financial_record.valid?
          financial_sale_record = FinancialGarmentReturnSale.new
          financial_sale_record.peca_venda_retorno = @garment_sale_return
          financial_sale_record.registro_financeiro = financial_record
          financial_sale_record.save
          #flash[:notice] << financial_sale_record.valid?
        end

        unless (@financial[:valor].to_s == '0.0')
          financial_record = FinancialRecord.new(valor: @financial[:valor], tipo_movimento: 'Entrada', observacao: @financial[:observacao], data_hora: params[:data_hora])
          #
          observacao_original = financial_record.observacao
          pre_msg = 'Venda Retorno'
          pre_msg += ' - ' unless observacao_original.blank?
          financial_record.observacao = pre_msg + financial_record.observacao
          #
          financial_record.save
          #flash[:notice] << financial_record.valid?
          financial_sale_record = FinancialGarmentReturnSale.new
          financial_sale_record.peca_venda_retorno = @garment_sale_return
          financial_sale_record.registro_financeiro = financial_record
          financial_sale_record.save
          #flash[:notice] << financial_sale_record.valid?
        end
        flash[:notice] << 'Finalizado com sucesso!'
        redirect_to root_path
        return
      end
    end

    render :return
  end

  def get_total_quantity_finished
    garment_type_id = params[:garment_type_id]
    total_quantity = GarmentFinishedStock.where(tipo_peca_id: garment_type_id).last
    
    unless total_quantity.nil?
      total_quantity = total_quantity[:saldo]
    else
      total_quantity = 0
    end
    
    session[:pecas].each do |peca|
      if (peca["garment_type_id"] == garment_type_id)
        total_quantity = total_quantity - peca["quantidade"].to_i
      end
    end

    total_quantity = 0 if total_quantity < 0

    render json: { total_quantity: total_quantity }
  end

  private

  def financial_validate(financial, data_hora)
    financial_record = FinancialRecord.new(valor: financial['valor'], tipo_movimento: 'Saída', observacao: financial['observacao'], data_hora: data_hora)
    financial_record.valid?
    @financial_errors = financial_record.errors
    financial_record.valid?
  end

  def set_garment_types
    garment_stocks_finished_groups = GarmentFinishedStock.all.group_by { |garment_finished_stock| [garment_finished_stock.tipo_peca.nome] }

    garment_stocks_finished_groups.each do |garment_finished_stock_group|
      last = garment_finished_stock_group[1].last

      if last.saldo <= 0
        garment_stocks_finished_groups.delete(garment_finished_stock_group[0])
      end
    end

    @garment_types = garment_stocks_finished_groups.map { |garment_finished_stock_group| garment_finished_stock_group[1].last.tipo_peca }.uniq
  end

  def set_entities(entity_type)
    entity_type = EntityType.find_by(nome: 'Vendedor')
    @vendedores = Entity.ativo.where(entity_type: entity_type)
  end
end
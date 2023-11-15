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

    @garment_sale_exit = GarmentSaleExit.new
    @garment_sale_exit.data_hora = params[:data_hora]
    @garment_sale_exit.vendedor_id = params[:vendedor_id]

    @garment_sale_exit.data_hora = params[:data_hora] || session[:data_hora]
    @garment_sale_exit.vendedor_id = params[:vendedor_id] || session[:vendedor_id]
    
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
    end

    flash[:notice] << 'Saida para venda criada com sucesso!'
    redirect_to root_path
  end

  def return
    session.delete(:pecas)
    session.delete(:financial_extra)
    session[:pecas] ||= []
    session[:financial_extra] ||= []

    set_garment_types
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

    render :return
  end

  private

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
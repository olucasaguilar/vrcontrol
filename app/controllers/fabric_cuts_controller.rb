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
    @fabric_cut = FabricCut.new(fabric_cut_params)
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
    if (FabricCut.any? && (FabricCut.last.finalizado == false))
      @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
      colors_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
      fabric_types_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][0] }.uniq
      @fabric_types = FabricType.where(nome: fabric_types_estoque)
      @colors = Color.where(nome: colors_estoque)
      @garment_types = GarmentType.all
      
      @fabric_stocks = [FabricStock.new]
    #   @fabric_types = FabricType.all
    #   @valores_tecido = []
    #   @valor_erro_index = []
    else
      redirect_to new_fabric_cut_path
    end
  end

  def create_details__
    @fabric_stocks = []
    @fabric_types = FabricType.all
    @colors = Color.all
    all_valid_fabric = true

    params[:fabric_stock].each do |parametro|
      fabric_stock = FabricStock.new(fabric_stock_params(parametro[1]))
      fabric_stock.tipo_movimento = 'Saida'
      fabric_stock.data_hora = FabricCut.last.data_hora
      all_valid_fabric = false unless fabric_stock.valid?
      @fabric_stocks << fabric_stock
    end

    total_peso = @fabric_stocks.each.map { |fabric_stock| fabric_stock.quantidade }
    total_peso = total_peso.sum

    unless all_valid
      render :new_details and return
    end

    # Debug
    #render :new_details and return
    # Debug

    @fabric_stocks.each do |fabric_stock|
      fabric_stock.save
      
      @fabric_stock_entry = FabricStockEntry.new
      @fabric_stock_entry.entrada_tecido = FabricEntry.last
      @fabric_stock_entry.estoque_tecido = fabric_stock
      @fabric_stock_entry.valor_tecido = @valores_tecido[@fabric_stocks.index(fabric_stock)]
      @fabric_stock_entry.save if @fabric_stock_entry.valid?
    end

    FabricEntry.last.update(total_tecido: total_peso)

    flash[:notice] << 'Entrada de tecido(s) criada com sucesso!'
    redirect_to new_fabric_entry_path # Temp
  end

  def return    
  end

  private

  def busca_cortadores
    entity_type_cortador = EntityType.find_by(nome: 'Cortador')
    @cortadores = Entity.where(entity_type: entity_type_cortador)
  end

  def fabric_cut_params
    params.require(:fabric_cut).permit(:data_hora_ida, :cortador_id)
  end

  def fabric_stock_params(parametros)
    parametros.permit(:tipo_tecido_id, :cor_id, :quantidade)
  end  
end

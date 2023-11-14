class FabricEntriesController < ApplicationController
  def new
    # Alterar de unless para if
    if FabricEntry.any? && FabricEntry.last.total_tecido == nil
      redirect_to new_fabric_entry_details_path
    else
      data_hora = Time.now - 3.hour
      buscar_entidades('Malharia')
      @fabric_entry = FabricEntry.new
      @fabric_entry.data_hora = data_hora
      
      @financial_records = []
    end
  end

  def create    
    @fabric_entry = FabricEntry.new(fabric_entry_params)
    @financial_records = []
    all_valid = true
    
    unless params[:valor].nil?
      params[:valor].each_with_index do |valor, index|
        tipo_movimento = 'Saída'
        observacao = params[:observacao][index]
        data_hora = @fabric_entry.data_hora
        financial_record = FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
        financial_record.valor = valor.delete("^0-9,").tr(',', '.').to_f
        @financial_records << financial_record
      end
      
      @financial_records.each do |financial_record|
        unless financial_record.valid?
          all_valid = false
        end      
      end
    end
    
    if @fabric_entry.valid? && all_valid
      flash[:notice] = []
      @fabric_entry.save
      
      @financial_records.each do |financial_record|
        observacao_original = financial_record.observacao
        pre_msg = 'Entrada Tecido - Custo Extra'
        pre_msg += ' - ' unless observacao_original.blank?
        financial_record.observacao = pre_msg + financial_record.observacao
        financial_record.save

        financial_fabric_entry = FinancialFabricEntry.new(
          registro_financeiro: financial_record,
          entrada_tecido: @fabric_entry
        )

        if financial_fabric_entry.valid?
          financial_fabric_entry.save
          # Temp
          flash[:notice] << 'Vinculo entre movimentação de caixa e entrada de tecido criado com sucesso!'
        else
          flash[:notice] << 'Erro ao criar o vinculo entre movimentação de caixa e entrada de tecido!'
        end
      end
      # Temp
      if @financial_records.any?
        flash[:notice] << 'Movimentação de caixa criada com sucesso!'
      end

      flash[:notice] << 'Entrada de tecido criada com sucesso!'
      redirect_to new_fabric_entry_details_path
    else
      buscar_entidades('Malharia')
      render :new
    end
  end

  def new_details
    if FabricEntry.any? && FabricEntry.last.total_tecido == nil
      buscar_entidades('Malharia')
      @entidade = 'Malharia'
      @selected_entity = FabricEntry.last.entity_id
      @data_hora = FabricEntry.last.data_hora

      @fabric_stocks = [FabricStock.new]
      @fabric_types = FabricType.all
      @colors = Color.all
      @valores_tecido = []
      @valor_erro_index = []
      @financial_record = FinancialRecord.new
      @financial_record.valor = 0
    else
      redirect_to new_fabric_entry_path
    end
  end

  def create_details
    buscar_entidades('Malharia')
    @entidade = 'Malharia'
    @selected_entity = params[:entidade_id]
    @data_hora = params[:data_hora].to_datetime
    FabricEntry.last.update(entity_id: @selected_entity)
    FabricEntry.last.update(data_hora: @data_hora)

    @fabric_stocks = []
    @fabric_types = FabricType.all
    @colors = Color.all
    flash[:notice] = []
    all_valid = true

    params[:fabric_stock].each do |parametro|
      before_instance = fabric_stock_params(parametro[1])
      before_instance[:quantidade] = before_instance[:quantidade].delete("^0-9,").tr(',', '.').to_f
      fabric_stock = FabricStock.new(before_instance)
      fabric_stock.tipo_movimento = 'Entrada'
      fabric_stock.data_hora = FabricEntry.last.data_hora
      all_valid = false unless fabric_stock.valid?
      @fabric_stocks << fabric_stock
    end
    
    @valores_tecido = []
    index = 0
    @valor_erro_index = []
    params[:valor_tecido].each do |parametro|
      # parametro[1] == valor do tecido
      # @fabric_stocks[parametro[0].to_i] == tecido
      valor = parametro[1].delete("^0-9,").tr(',', '.').to_f
      @valores_tecido << valor
      unless valor > 0
        all_valid = false
        @valor_erro_index << index
      end
      index += 1
    end  

    @financial_record = FinancialRecord.new
    @financial_record.valor = @valores_tecido.sum
    @financial_record.valor = 0 unless @valor_erro_index.empty?
    @financial_record.observacao = params[:FinancialRecord][:observacao]
    @financial_record.tipo_movimento = 'Saída'
    @financial_record.data_hora = FabricEntry.last.data_hora
    all_valid = false unless @financial_record.valid?
    total_peso = @fabric_stocks.each.map { |fabric_stock| fabric_stock.quantidade }
    total_peso = total_peso.each_with_index { |peso, index| total_peso[index] = peso.to_f }

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

    observacao_original = @financial_record.observacao
    pre_msg = 'Entrada Tecido - Custo'
    pre_msg += ' - ' unless observacao_original.blank?
    @financial_record.observacao = pre_msg + @financial_record.observacao
    @financial_record.save

    financial_fabric_entry = FinancialFabricEntry.new(
      registro_financeiro: @financial_record,
      entrada_tecido: FabricEntry.last
    )
    
    if financial_fabric_entry.valid?
      financial_fabric_entry.save
    end

    FabricEntry.last.update(total_tecido: total_peso)

    flash[:notice] << 'Entrada de tecido(s) criada com sucesso!'
    redirect_to new_fabric_entry_path # Temp
  end

  private

  def fabric_entry_params
    params.require(:fabric_entry).permit(:data_hora, :entity_id)
  end

  def fabric_stock_params(parametros)
    parametros.permit(:tipo_tecido_id, :cor_id, :quantidade)
  end  
end

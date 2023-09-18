class FabricEntriesController < ApplicationController
  def new
    # Alterar de unless para if
    unless FabricEntry.any? && FabricEntry.last.total_tecido == nil
      redirect_to new_fabric_entry_details_path
    else
      data_hora = Time.now - 3.hour
      busca_malharias()
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
        @financial_records << FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
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
      end
      if @financial_records.any?
        flash[:notice] << 'Movimentação de caixa criada com sucesso!'
      end

      flash[:notice] << 'Entrada de tecido criada com sucesso!'
      redirect_to new_fabric_entry_details_path
    else
      busca_malharias()
      render :new
    end
  end

  def new_details
    if FabricEntry.any? && FabricEntry.last.total_tecido == nil
      @fabric_stocks = []
      @fabric_stocks << FabricStock.new
      @fabric_types = FabricType.all
      @colors = Color.all
    else
      redirect_to new_fabric_entry_path
    end
  end

  def create_details
    @fabric_stocks = []
    parametros = extract_fabric_stock()
    parametros.count do |parametro|
      @fabric_stocks << FabricStock.new(fabric_stock_params(parametro))
      @fabric_stocks.last.tipo_movimento = 'Entrada'
      @fabric_stocks.last.data_hora = FabricEntry.last.data_hora
    end

    all_valid = true
    @fabric_stocks.each do |fabric_stock|
      unless fabric_stock.valid?
        all_valid = false
      end      
    end

    unless all_valid
      @fabric_types = FabricType.all
      @colors = Color.all
      render :new_details
      return
    end

    flash[:notice] = 'Entrada de tecido (details) criada com sucesso!'
    @fabric_stocks.each do |fabric_stock|
      fabric_stock.save
    end
    redirect_to new_fabric_entry_details_path
  end

  private

  def extract_fabric_stock
    parametros = []
    params.each do |key, value|
      if key.include? 'fabric_stock'
        parametros << value
      end
    end
    parametros
  end

  def busca_malharias
    entity_type_malharia = EntityType.find_by(nome: 'Malharia')
    @malharias = Entity.where(entity_type: entity_type_malharia)
  end

  def fabric_entry_params
    params.require(:fabric_entry).permit(:data_hora, :entity_id)
  end

  def fabric_stock_params
    params.require(:fabric_stock).permit(:tipo_tecido_id, :cor_id, :quantidade)
  end

  def fabric_stock_params(parametros)
    parametros.permit(:tipo_tecido_id, :cor_id, :quantidade)
  end
end

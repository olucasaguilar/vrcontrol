class FabricEntriesController < ApplicationController
  def new
    # Alterar de unless para if
    if FabricEntry.any? && FabricEntry.last.total_tecido == nil
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
      busca_malharias()
      render :new
    end
  end

  def new_details
    if FabricEntry.any? && FabricEntry.last.total_tecido == nil
      @fabric_stocks = [FabricStock.new]
      @fabric_types = FabricType.all
      @colors = Color.all
      @valores_tecido = []
    else
      redirect_to new_fabric_entry_path
    end
  end

  def create_details
    @fabric_stocks = []
    @fabric_types = FabricType.all
    @colors = Color.all
    flash[:notice] = []
    all_valid = true

    params[:fabric_stock].each do |parametro|
      fabric_stock = FabricStock.new(fabric_stock_params(parametro[1]))
      fabric_stock.tipo_movimento = 'Entrada'
      fabric_stock.data_hora = FabricEntry.last.data_hora
      all_valid = false unless fabric_stock.valid?
      @fabric_stocks << fabric_stock
    end

    @valores_tecido = []
    params[:valor_tecido].each do |parametro|
      # parametro[1] == valor do tecido
      # @fabric_stocks[parametro[0].to_i] == tecido
      @valores_tecido << parametro[1].to_f
    end

    # @valores_tecido será o valor salvo no FinancialRecord

    # Debug
    #render :new_details and return
    # Debug

    unless all_valid
      render :new_details and return
    end
    
    @fabric_stocks.each do |fabric_stock|
      fabric_stock.save
    end

    flash[:notice] = 'Entrada de tecido(s) criada com sucesso!'
    redirect_to new_fabric_entry_details_path # Temp
  end

  private

  def busca_malharias
    entity_type_malharia = EntityType.find_by(nome: 'Malharia')
    @malharias = Entity.where(entity_type: entity_type_malharia)
  end

  def fabric_entry_params
    params.require(:fabric_entry).permit(:data_hora, :entity_id)
  end

  def fabric_stock_params(parametros)
    parametros.permit(:tipo_tecido_id, :cor_id, :quantidade)
  end  
end

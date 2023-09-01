class FabricEntriesController < ApplicationController
  def new
    data_hora = Time.now - 3.hour
    busca_malharias()

    @fabric_entry = FabricEntry.new
    @fabric_entry.data_hora = data_hora
    
    
    @financial_record = FinancialRecord.new
  end

  def create
    @have_extra = true if params[:fabric_entry][:have_extra] == '1'
    @valor_extra = params[:fabric_entry][:valor_extra]
    @obs_extra = params[:fabric_entry][:obs_extra]
    
    @fabric_entry = FabricEntry.new(fabric_entry_params)
    
    if @have_extra == true
      observacao_original = @obs_extra
      pre_msg = 'Entrada Tecido - Custo Extra'
      pre_msg += ' - ' unless observacao_original.blank?
      @obs_extra = pre_msg + @obs_extra

      valor = @valor_extra.to_f
      tipo_movimento = 'Saída'
      observacao = @obs_extra
      data_hora = @fabric_entry.data_hora
      @financial_record = FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
      
      @financial_record.valid?
    else
      @financial_record = FinancialRecord.new
    end

    if @have_extra == true
      if @fabric_entry.valid? && @financial_record.valid?
        @fabric_entry.save
        @financial_record.save

        @financial_fabric_entry = FinancialFabricEntry.new(
          registro_financeiro: @financial_record,
          entrada_tecido: @fabric_entry
        )
            
        if @financial_fabric_entry.valid?
          @financial_fabric_entry.save
        end

        messages = [
          'Entrada de tecido criada com sucesso!',
          'Movimentação de caixa criada com sucesso!'
        ]
        
        flash[:notice] = messages
        redirect_to new_fabric_entry_path # alterar depois
      else
        @obs_extra = observacao_original
        busca_malharias()
        render :new
      end
    else
      if @fabric_entry.valid?
        @fabric_entry.save
        flash[:notice] = 'Entrada de tecido criada com sucesso!'
        redirect_to new_fabric_entry_path
      else
        busca_malharias()
        render :new
      end
    end
  end

  private

  def busca_malharias
    entity_type_malharia = EntityType.find_by(nome: 'Malharia')
    @malharias = Entity.where(entity_type: entity_type_malharia)
  end

  def fabric_entry_params
    params[:fabric_entry].delete(:have_extra)
    params[:fabric_entry].delete(:valor_extra)
    params[:fabric_entry].delete(:obs_extra)

    params.require(:fabric_entry).permit(:data_hora, :entity_id)
  end
end

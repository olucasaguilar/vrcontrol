class FabricEntriesController < ApplicationController
  def new
    data_hora = Time.now - 3.hour
    busca_malharias()

    @fabric_entry = FabricEntry.new
    @fabric_entry.data_hora = data_hora
    
    
    @financial_record = FinancialRecord.new

    busca_registros()
  end

  def create
    @have_extra = true if params[:fabric_entry][:have_extra] == '1'
    @valor_extra = params[:fabric_entry][:valor_extra]
    @obs_extra = params[:fabric_entry][:obs_extra]
    
    @fabric_entry = FabricEntry.new(fabric_entry_params)

    observacao_original = @obs_extra
    pre_msg = 'Entrada Tecido - Extra'
    pre_msg += ' - ' unless observacao_original.blank?
    @obs_extra = pre_msg + @obs_extra

    valor = @valor_extra.to_f
    tipo_movimento = 'Entrada'
    observacao = @obs_extra
    data_hora = @fabric_entry.data_hora
    @financial_record = FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
    
    @financial_record.valid?
    
    if @fabric_entry.valid? && @financial_record.valid?
      @fabric_entry.save
      @financial_record.save
      flash[:notice] = 'Entrada de tecido criada com sucesso!', 'Movimentação de caixa criada com sucesso!'
      redirect_to new_fabric_entry_path # alterar depois
    else
      @obs_extra = observacao_original
      busca_malharias()
      busca_registros()
      render :new
    end
  end

  # temporário
  def destroy_all
    FabricEntry.destroy_all
    redirect_to new_fabric_entry_path, notice: 'Entradas de tecido excluídas com sucesso!'
  end

  # temporario
  def busca_registros
    @fabric_entries = FabricEntry.all
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

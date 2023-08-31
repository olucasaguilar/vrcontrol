class FabricEntriesController < ApplicationController
  def new
    @fabric_entry = FabricEntry.new
    @fabric_entry.data_hora = Time.now
    busca_malharias()
    @fabric_entries = FabricEntry.all
  end

  def create
    @fabric_entry = FabricEntry.new(fabric_entry_params)
    @fabric_entries = FabricEntry.all

    if @fabric_entry.save      
      redirect_to new_fabric_entry_path, notice: 'Entrada de tecido criada com sucesso!'
    else
      busca_malharias()
      render :new
    end
  end

  # Temporário
  def destroy_all
    FabricEntry.destroy_all
    redirect_to new_fabric_entry_path, notice: 'Entradas de tecido excluídas com sucesso!'
  end

  private

  def busca_malharias
    entity_type_malharia = EntityType.find_by(nome: 'Malharia')
    @malharias = Entity.where(entity_type: entity_type_malharia)
  end

  def fabric_entry_params
    params.require(:fabric_entry).permit(:data_hora, :entity_id)
  end
end

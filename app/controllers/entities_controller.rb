class EntitiesController < ApplicationController
  before_action :set_entity, only: [:edit, :show, :update, :destroy]

  def entities_by_type
    @entity_types = EntityType.all
  end

  def filter_by_type
    if EntityType.exists?(params[:entity_type_id]) && Entity.exists?(entity_types_id: params[:entity_type_id])
      @entities = Entity.where(entity_types_id: params[:entity_type_id])
    else
      @entities = []
      @entity_type = EntityType.find(params[:entity_type_id])
    end
  end

  def show    
  end

  def edit
    @entity_types = EntityType.all    
  end

  def update
    if @entity.update(entity_params)
      redirect_to filter_by_type_path(entity_type_id: @entity.entity_types_id), notice: 'Entidade atualizada com sucesso'
    else
      redirect_to filter_by_type_path(entity_type_id: @entity.entity_types_id), alert: 'Erro ao atualizar entidade'
    end
  end

  def destroy
    if @entity.destroy
      redirect_to filter_by_type_path(entity_type_id: @entity.entity_types_id), notice: 'Entidade excluída com sucesso'
    else
      redirect_to filter_by_type_path(entity_type_id: @entity.entity_types_id), alert: 'Erro ao excluir entidade'
    end
  end

  private

  def set_entity
    @entity = Entity.find(params[:id])
  end

  def entity_params
    params.require(:entity).permit(:nome, :num_contato, :cidade, :estado, :entity_types_id)
  end
end

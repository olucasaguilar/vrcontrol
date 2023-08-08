class EntitiesController < ApplicationController
  def entities_by_type
    @entity_types = EntityType.all
  end

  def filter_by_type
    if EntityType.exists?(params[:entity_type_id]) && Entity.exists?(entity_types_id: params[:entity_type_id])
      @entities = Entity.where(entity_types_id: params[:entity_type_id])
    else
      redirect_to entities_by_type_path, info: 'No entities found for this type'
    end
  end
end

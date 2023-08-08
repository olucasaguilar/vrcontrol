class EntityTypesController < ApplicationController
  before_action :set_entity_type, only: [:edit, :update, :destroy]

  def index
    @entity_types = EntityType.all
  end

  def new
    @entity_type = EntityType.new
  end

  def create
    @entity_type = EntityType.new(entity_type_params)

    if @entity_type.save
      redirect_to entity_types_path, notice: 'Tipo de entidade criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @entity_type.update(entity_type_params)
      redirect_to entity_types_path, notice: 'Tipo de entidade atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @entity_type.destroy
      redirect_to entity_types_path, notice: 'Tipo de entidade excluído com sucesso.'
    else
      redirect_to entity_types_path, alert: 'Erro ao excluir tipo de entidade'
    end
  end

  private

  def set_entity_type
    @entity_type = EntityType.find(params[:id])
  end

  def entity_type_params
    params.require(:entity_type).permit(:nome)
  end
end

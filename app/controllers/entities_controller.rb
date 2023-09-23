class EntitiesController < ApplicationController
  include Pagy::Backend

  before_action :set_entity, only: [:edit, :show, :update, :destroy]

  def index
    @entity_types = EntityType.all
    if params[:filter] != "" && params[:filter] != nil
      entity_type = EntityType.where(id: params[:filter]).first
      if entity_type != nil
        @entities = Entity.where(entity_types_id: entity_type.id).all
      else
        @entities = []
      end
    else
      @entities = Entity.all
    end

    @quant_items = [4, 6, 8, 10, 16, 20]
    
    quant = params[:quant]
    quant = 6 if quant == nil || quant == "" || quant.to_i <= 0
    quant = 20 if quant.to_i > 20
    page = params[:page]
    if page == nil || page == "" || page.to_i <= 0
      page = 1
    else
      page = page.to_i
    end
    if page > (@entities.count / quant.to_f).ceil
      page = (@entities.count / quant.to_f).ceil      
    end

    @pagy, @entities = pagy(@entities, items: quant, page: page)

    flash[:notice] = []
    #flash[:notice] << params.inspect
  end

  def show    
  end

  def edit
    @entity_types = EntityType.all    
  end

  def update
    if @entity.update(entity_params)
      #redirect_to entidades_path, notice: 'Entidade atualizada com sucesso'
      redirect_to entity_path(@entity.id), notice: 'Entidade atualizada com sucesso'
    else
      @entity_types = EntityType.all   
      render :edit
    end
  end

  def new
    @entity_types = EntityType.all
    @entity = Entity.new
    @entity[:entity_types_id] = params[:id]
  end

  def create
    @entity = Entity.new(entity_params)

    if @entity.save
      redirect_to entity_path(@entity.id), notice: 'Entidade criada com sucesso'
    else
      @entity_types = EntityType.all
      render :new
    end
  end

  def destroy
    if @entity.destroy
      redirect_to entidades_path, notice: 'Entidade excluída com sucesso'
    else
      redirect_to entity_path(@entity.id), alert: 'Erro ao excluir entidade'
    end
  end

  private

  def set_entity
    @entity = Entity.find(params[:id])
  end

  def entity_params
    params.require(:entity).permit(:nome, :num_contato, :cidade, :estado, :cnpj, :ie, :entity_types_id)
  end
end

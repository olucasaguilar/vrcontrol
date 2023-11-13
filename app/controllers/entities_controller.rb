class EntitiesController < ApplicationController
  include Pagy::Backend
  before_action :set_entity, only: [:edit, :show, :update, :destroy]
  before_action :verify_entities_create, only: [:edit, :new, :update, :create]
  before_action :verify_entities, only: [:index]

  def index
    flash[:notice] = []

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

    if params[:search].present?
      @entities = Entity.where("nome ILIKE ? OR cidade ILIKE ? OR estado ILIKE ?",
                                "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end

    if params[:sort] != "" && params[:sort] != nil
      if params[:sort] == "nome"
        @entities = @entities.order(:nome)
      elsif params[:sort] == "cidade"
        @entities = @entities.order(:cidade)
      elsif params[:sort] == "estado"
        @entities = @entities.order(:estado)
      elsif params[:sort] == "nome_"
        @entities = @entities.order(nome: :desc)
      elsif params[:sort] == "cidade_"
        @entities = @entities.order(cidade: :desc)
      elsif params[:sort] == "estado_"
        @entities = @entities.order(estado: :desc)
      end
    end

    page = params[:page]
    if page == nil || page == "" || page.to_i <= 0
      page = 1
    else
      page = page.to_i
    end

    @pagy, @entities = pagy(@entities, page: page, items: 5)
  end

  def show; end

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

  def verify_entities_create    
    unless current_user.user_permission.entities_create || current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end

  def verify_entities
    unless current_user.user_permission.entities || current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end

  def set_entity
    @entity = Entity.find(params[:id])
  end

  def entity_params
    params.require(:entity).permit(:nome, :num_contato, :cidade, :estado, :cnpj, :ie, :entity_types_id)
  end
end

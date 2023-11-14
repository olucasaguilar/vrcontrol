class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  add_flash_types :info
  before_action :menu_status
  before_action :validate_error
  
  skip_before_action :verify_authenticity_token, only: [:atualizar_menu_status]
  def atualizar_menu_status
    session.delete(:menu_status)
    session[:menu_status] = params[:status]
    #render json: { 'params[:status]': params[:status], 'session[:menu_status]': session[:menu_status] }
  end
  
  private

  def buscar_entidades(tipo)
    entity_type = EntityType.find_by(nome: tipo)
    @entidades = Entity.ativo.where(entity_type: entity_type)
  end

  def menu_status
    session[:menu_status] = 'false' if session[:menu_status].nil?
  end

  def validate_error
    begin; GarmentScreenGarments; rescue StandardError => e; end
  end
end

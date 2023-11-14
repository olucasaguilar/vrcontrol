class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  add_flash_types :info
  
  private

  def buscar_entidades(tipo)
    entity_type = EntityType.find_by(nome: tipo)
    @entidades = Entity.ativo.where(entity_type: entity_type)
  end
end

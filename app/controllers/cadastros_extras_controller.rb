class CadastrosExtrasController < ApplicationController
  def index
    @tipos_de_entidade = entity_types_path
    @tipos_de_tecido = fabric_types_path
    @cores = colors_path
  end
end

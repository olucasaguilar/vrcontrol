class CadastrosExtrasController < ApplicationController
  def index
    @tipos_de_entidade = entity_types_path
  end
end

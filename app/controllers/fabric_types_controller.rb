class FabricTypesController < ApplicationController
  before_action :set_fabric_type, only: [:edit, :update, :destroy]

  def index
    @fabric_types = FabricType.all
  end

  def new
    @fabric_type = FabricType.new
  end

  def create
    @fabric_type = FabricType.new(fabric_type_params)

    if @fabric_type.save
      redirect_to fabric_types_path, notice: 'Tipo de tecido criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @fabric_type.update(fabric_type_params)
      redirect_to fabric_types_path, notice: 'Tipo de tecido atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @fabric_type.destroy
      redirect_to fabric_types_path, notice: 'Tipo de tecido excluído com sucesso.'
    else
      redirect_to fabric_types_path, alert: 'Erro ao excluir tipo de tecido'
    end
  end

  private

  def set_fabric_type
    @fabric_type = FabricType.find(params[:id])
  end

  def fabric_type_params
    params.require(:fabric_type).permit(:nome)
  end
end

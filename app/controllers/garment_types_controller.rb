class GarmentTypesController < ApplicationController
  before_action :set_garment_type, only: [:edit, :update, :destroy]

  def index
    @garment_types = GarmentType.all
  end

  def new
    @garment_type = GarmentType.new
  end

  def create
    @garment_type = GarmentType.new(garment_type_params)

    if @garment_type.save
      redirect_to garment_types_path, notice: 'Tipo de vestuário criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @garment_type.update(garment_type_params)
      redirect_to garment_types_path, notice: 'Tipo de vestuário atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @garment_type.destroy
      redirect_to garment_types_path, notice: 'Tipo de vestuário excluído com sucesso.'
    else
      redirect_to garment_types_path, alert: 'Erro ao excluir tipo de vestuário.'
    end
  end

  private

  def set_garment_type
    @garment_type = GarmentType.find(params[:id])
  end

  def garment_type_params
    params.require(:garment_type).permit(:nome)
  end
end

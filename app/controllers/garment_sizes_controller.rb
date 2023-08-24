class GarmentSizesController < ApplicationController
  before_action :set_garment_size, only: [:edit, :update, :destroy]

  def index
    @garment_sizes = GarmentSize.all
  end

  def new
    @garment_size = GarmentSize.new
  end

  def create
    @garment_size = GarmentSize.new(garment_size_params)

    if @garment_size.save
      redirect_to garment_sizes_path, notice: 'Tamanho de vestuário criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @garment_size.update(garment_size_params)
      redirect_to garment_sizes_path, notice: 'Tamanho de vestuário atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @garment_size.destroy
      redirect_to garment_sizes_path, notice: 'Tamanho de vestuário excluído com sucesso.'
    else
      redirect_to garment_sizes_path, alert: 'Erro ao excluir tamanho de vestuário.'
    end
  end

  private

  def set_garment_size
    @garment_size = GarmentSize.find(params[:id])
  end

  def garment_size_params
    params.require(:garment_size).permit(:nome)
  end
end

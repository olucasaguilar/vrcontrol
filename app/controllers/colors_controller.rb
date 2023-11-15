class ColorsController < ExtrasController
  before_action :set_color, only: [:edit, :update, :destroy]

  def index
    @colors = Color.all
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)

    if @color.save
      redirect_to colors_path, notice: 'Cor criada com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @color.update(color_params)
      redirect_to colors_path, notice: 'Cor atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    begin
      if @color.destroy
        redirect_to colors_path, notice: 'Cor excluída com sucesso.'
      end
    rescue StandardError => e
      redirect_to colors_path, alert: 'Não foi possível excluir a cor.'
    end
  end

  private

  def set_color
    @color = Color.find(params[:id])
  end

  def color_params
    params.require(:color).permit(:nome)
  end
end

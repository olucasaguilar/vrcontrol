class FinancialRecordsController < ApplicationController
  include Pagy::Backend
  before_action :verify_financial_create, only: [:new, :create]
  before_action :verify_financial, only: [:index]

  def index
    @financial_records = FinancialRecord.order(id: :desc).all
    @saldo = FinancialRecord.last.saldo if @financial_records.any?

    page = params[:page]
    if page == nil || page == "" || page.to_i <= 0
      page = 1
    else
      page = page.to_i
    end
    
    @pagy, @financial_records = pagy(@financial_records, items: 6, page: page)
  end

  def new
    @financial_record = FinancialRecord.new
    @financial_record.data_hora = DateTime.now - 3.hour
  end

  def create
    @financial_record = FinancialRecord.new(financial_record_params)

    observacao_original = @financial_record.observacao
    pre_msg = 'Mov. manual'
    pre_msg += ' - ' unless observacao_original.blank?
    @financial_record.observacao = pre_msg + @financial_record.observacao
    
    if @financial_record.save
      redirect_to financial_records_path, notice: 'Movimentação de caixa criada com sucesso!'
    else
      @financial_record.observacao = observacao_original
      render 'new'
    end
  end

  private

  def financial_record_params
    params.require(:financial_record).permit(:valor, :tipo_movimento, :observacao, :data_hora)
  end

  def verify_financial_create    
    unless current_user.user_permission.financial_create || current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end

  def verify_financial
    unless current_user.user_permission.financial || current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end
end
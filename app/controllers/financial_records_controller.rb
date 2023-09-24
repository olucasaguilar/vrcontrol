class FinancialRecordsController < ApplicationController
  def index
    @financial_records = FinancialRecord.all
    @saldo = FinancialRecord.last.saldo if @financial_records.any?
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

  def temp_view
  end

  private

  def financial_record_params
    params.require(:financial_record).permit(:valor, :tipo_movimento, :observacao, :data_hora)
  end
end
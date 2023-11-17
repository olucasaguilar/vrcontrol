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
    flash[:notice] = []
    @financial_record = FinancialRecord.new(financial_record_params)
    @financial_record.valor = params[:financial_record][:valor].delete("^0-9,").tr(',', '.').to_f

    
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

  def report
    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    pdf.text "Histórico de Registros Financeiros", size: 16, style: :bold
    pdf.move_down 10
  
    # Buscando todos os registros financeiros em ordem decrescente
    @financial_records = FinancialRecord.order(id: :desc).all
  
    # Criando uma tabela para a lista de registros financeiros
    table_data = [["#", "Tipo de Mov.", "Valor", "Saldo", "Observação", "Data e Hora"]]
  
    @financial_records.each_with_index do |record, index|
      # Formatação manual dos valores como moeda brasileira
      formatted_valor = "R$ #{'%.2f' % record.valor}"
      formatted_saldo = "R$ #{'%.2f' % record.saldo}"
  
      table_data << [
        index + 1,
        record.tipo_movimento,
        formatted_valor,
        formatted_saldo,
        record.observacao,
        record.data_hora.strftime("%d/%m/%Y %H:%M")
      ]
    end
  
    pdf.table(table_data, header: true, width: pdf.bounds.width) do
      row(0).font_style = :bold
    
      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'
    end
  
    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_registros_financeiros.pdf',
              type: 'application/pdf',
              disposition: 'inline')
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
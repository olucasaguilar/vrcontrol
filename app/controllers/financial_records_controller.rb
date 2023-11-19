class FinancialRecordsController < ApplicationController
  include Pagy::Backend
  before_action :verify_financial_create, only: [:new, :create]
  before_action :verify_financial, only: [:index]

  def index
    data_inicio = params[:data_inicio].to_datetime if params[:data_inicio] != nil
    data_fim = params[:data_fim].to_datetime if params[:data_fim] != nil
    
    data_inicio = (DateTime.now - 1.month) if data_inicio == nil
    data_fim = (DateTime.now) if data_fim == nil

    @data_inicio = data_inicio.change(hour: 0, minute: 0, second: 0)
    @data_fim = data_fim.change(hour: 23, minute: 59, second: 59)
    
    @financial_records = FinancialRecord.where("data_hora >= ? AND data_hora <= ?", @data_inicio, @data_fim).order(data_hora: :desc)
        
    @saldo = {}
    @financial_records.reverse.each_with_index do  |record, index|
      if index == 0
        if record.tipo_movimento == "Entrada"
          @saldo[record.id] = record.valor
        else
          @saldo[record.id] = -record.valor
        end
      else
        if record.tipo_movimento == "Entrada"
          @saldo[record.id] = @saldo.values[index - 1] + record.valor
        else
          @saldo[record.id] = @saldo.values[index - 1] - record.valor
        end
      end
    end
    
    return if params[:action] == "report"

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
    index

    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    pdf.text "Histórico de Registros Financeiros", size: 16, style: :bold
    pdf.move_down 10

    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12,
    size: 12, align: :right
    pdf.move_down 10

    # Período de consulta
    pdf.text "Período de Consulta: #{@data_inicio.strftime("%d/%m/%Y")} até #{@data_fim.strftime("%d/%m/%Y")}"
    pdf.move_down 10

    # Mostra o saldo (ultimo) na direita
    pdf.text "Ultimo Saldo: R$ #{'%.2f' % @saldo[@financial_records[0][:id]]}"
    pdf.move_down 10


    # Criando uma tabela para a lista de registros financeiros
    table_data = [["#", "Tipo de Mov.", "Valor", "Saldo", "Observação", "Data e Hora"]]
  
    @financial_records.each_with_index do |record, index|
      # Formatação manual dos valores como moeda brasileira
      formatted_valor = "R$ #{'%.2f' % record.valor}"
      formatted_saldo = "R$ #{'%.2f' % @saldo[record.id]}"
  
      table_data << [
        index + 1,
        record.tipo_movimento,
        formatted_valor,
        formatted_saldo,
        record.observacao,
        record.data_hora.strftime("%d/%m/%Y %H:%M")
      ]
    end
  
    pdf.table(table_data, header: true, width: pdf.bounds.width, row_colors: ['ECECEC', 'FFFFFF']) do
      row(0).font_style = :bold
    
      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'

      # Ajustando a largura da coluna "Observação"
      columns([4]).width = pdf.bounds.width - columns([0, 1, 2, 3, 5]).width
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
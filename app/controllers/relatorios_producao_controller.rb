class RelatoriosProducaoController < ApplicationController
  def index; end

  def historico
    @etapas = {
      :corte => 'Corte',
      :costura => 'Costura',
      :serigrafia => 'Serigrafia',
      :acabamento => 'Acabamento'
    }
  end

  def historico_listagem
    etapa = params[:etapa]
    @data_inicio = params[:data_inicio].to_datetime.change(hour: 0, minute: 0, second: 0)
    @data_fim = params[:data_fim].to_datetime.change(hour: 23, minute: 59, second: 59)
    
    if etapa == 'corte'
      gerar_historico_corte
    elsif etapa == 'costura'
      gerar_historico_costura
    elsif etapa == 'serigrafia'
      gerar_historico_serigrafia
    elsif etapa == 'acabamento'
      gerar_historico_acabamento
    end
  end

  private

  def gerar_historico_corte
    set_dados_corte

    # Criando o PDF
    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    #pdf.text "Histórico de Registros Financeiros", size: 16, style: :bold
    pdf.text "Relatório de Produção - Corte", size: 16, style: :bold
    pdf.move_down 10

    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12,
    size: 12, align: :right
    pdf.move_down 10

    # Período de consulta
    pdf.text "Período de Consulta: #{@data_inicio.strftime("%d/%m/%Y")} até #{@data_fim.strftime("%d/%m/%Y")}"
    pdf.move_down 10

    # Criando uma tabela para os dados de cortes de tecido
    fabric_cuts_table_data = [
      ["Cortador", "Data Ida", "Data Volta", "Total Tecido", "Expec.", "Total Peças"]
    ]

    @dados.each do |dados_corte|
      formated_fabric = "#{dados_corte[:total_tecido_envio].to_s.gsub('.', ',')} kg"
      fabric_cuts_table_data << [
        dados_corte[:cortador],
        dados_corte[:data_hora_ida],
        dados_corte[:data_hora_volta],
        formated_fabric,
        dados_corte[:rendimento],
        dados_corte[:total_peca_retorno]
      ]
    end

    if @dados.empty?
      fabric_cuts_table_data << [
        "Não há cortes de tecido no",
        "período",
        "selecionado",
        "",
        "",
        ""
      ]
    end

    pdf.table(fabric_cuts_table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold

      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'

      # Ajustando a largura das colunas
      columns(0).width = pdf.width_of("Cortador", size: 40)
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_registros_financeiros_e_cortes_tecido.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def gerar_historico_costura
    #
  end

  def gerar_historico_serigrafia
    #
  end

  def gerar_historico_acabamento
    #
  end

  def set_dados_corte
    fabric_cuts = FabricCut.where('data_hora_ida >= ? AND data_hora_ida <= ?', @data_inicio, @data_fim).order(data_hora_ida: :desc)
    fabric_stock_exits = FabricStockExit.where('tecido_corte_id IN (?)', fabric_cuts.map(&:id))

    @dados = []
    fabric_cuts.each do |fabric_cut|
      dados_corte = {}
      dados_corte[:cortador] = fabric_cut.cortador.nome
      dados_corte[:data_hora_ida] = fabric_cut.data_hora_ida.strftime('%d/%m/%Y')
      dados_corte[:data_hora_volta] = fabric_cut.data_hora_volta.strftime('%d/%m/%Y') unless fabric_cut.data_hora_volta.nil?
      dados_corte[:total_tecido_envio] = fabric_cut.total_tecido_envio.round(2)
      dados_corte[:total_peca_retorno] = fabric_cut.total_peca_retorno.to_i if fabric_cut.total_peca_retorno.to_i > 0
      dados_corte[:rendimento] = fabric_stock_exits.where('tecido_corte_id = ?', fabric_cut.id).first.rendimento.to_i
      @dados << dados_corte
    end
  end
end

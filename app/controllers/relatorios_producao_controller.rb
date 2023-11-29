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
              filename: 'relatorio_producao_corte.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def gerar_historico_costura
    set_dados_costura

    # Criando o PDF
    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    #pdf.text "Histórico de Registros Financeiros", size: 16, style: :bold
    pdf.text "Relatório de Produção - Costura", size: 16, style: :bold
    pdf.move_down 10

    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12,
    size: 12, align: :right
    pdf.move_down 10

    # Período de consulta
    pdf.text "Período de Consulta: #{@data_inicio.strftime("%d/%m/%Y")} até #{@data_fim.strftime("%d/%m/%Y")}"
    pdf.move_down 10

    # Criando uma tabela para os dados de costura
    garment_sewings_table_data = [
      ["Costureira", "Data Ida", "Data Volta", "Total Peças", "Total Peças"]
    ]

    @dados.each do |dados_costura|
      garment_sewings_table_data << [
        dados_costura[:costureira],
        dados_costura[:data_hora_ida],
        dados_costura[:data_hora_volta],
        dados_costura[:total_pecas_envio],
        dados_costura[:total_pecas_retorno]
      ]
    end

    pdf.table(garment_sewings_table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold

      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'

      # Ajustando a largura das colunas
      columns(0).width = pdf.width_of("Costureira", size: 40)
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_producao_costura.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def gerar_historico_serigrafia
    set_dados_serigrafia

    # Criando o PDF
    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    #pdf.text "Histórico de Registros Financeiros", size: 16, style: :bold
    pdf.text "Relatório de Produção - Serigrafia", size: 16, style: :bold
    pdf.move_down 10

    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12,
    size: 12, align: :right
    pdf.move_down 10

    # Período de consulta
    pdf.text "Período de Consulta: #{Time.now.strftime("%d/%m/%Y")} até #{Time.now.strftime("%d/%m/%Y")}"
    pdf.move_down 10

    # Criando uma tabela para os dados de serigrafia
    garment_screen_printings_table_data = [
      ["Serigrafia", "Data Ida", "Data Volta", "Total Peças", "Total Peças"]
    ]

    @dados.each do |dados_serigrafia|
      garment_screen_printings_table_data << [
        dados_serigrafia[:serigrafia],
        dados_serigrafia[:data_hora_ida],
        dados_serigrafia[:data_hora_volta],
        dados_serigrafia[:total_pecas_envio],
        dados_serigrafia[:total_pecas_retorno]
      ]
    end

    pdf.table(garment_screen_printings_table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold

      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'

      # Ajustando a largura das colunas
      columns(0).width = pdf.width_of("Serigrafia", size: 40)
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_producao_costura.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def gerar_historico_acabamento
    set_dados_acabamento

    # Criando o PDF
    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    #pdf.text "Histórico de Registros Financeiros", size: 16, style: :bold
    pdf.text "Relatório de Produção - Acabamento", size: 16, style: :bold
    pdf.move_down 10

    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12,
    size: 12, align: :right
    pdf.move_down 10

    # Período de consulta
    pdf.text "Período de Consulta: #{Time.now.strftime("%d/%m/%Y")} até #{Time.now.strftime("%d/%m/%Y")}"
    pdf.move_down 10

    # Criando uma tabela para os dados de acabamento
    garment_finishings_table_data = [
      ["Acabamento", "Data Ida", "Data Volta", "Total Peças", "Total Peças"]
    ]

    @dados.each do |dados_acabamento|
      garment_finishings_table_data << [
        dados_acabamento[:acabamento],
        dados_acabamento[:data_hora_ida],
        dados_acabamento[:data_hora_volta],
        dados_acabamento[:total_pecas_envio],
        dados_acabamento[:total_pecas_retorno]
      ]
    end

    pdf.table(garment_finishings_table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold

      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'

      # Ajustando a largura das colunas
      columns(0).width = pdf.width_of("Acabamento", size: 40)
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_producao_costura.pdf',
              type: 'application/pdf',
              disposition: 'inline')              
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
      dados_corte[:rendimento] = fabric_stock_exits.where('tecido_corte_id = ?', fabric_cut.id).map(&:rendimento).sum.round
      @dados << dados_corte
    end
  end

  def set_dados_costura
    garment_sewings = GarmentSewing.where('data_hora_ida >= ? AND data_hora_ida <= ?', @data_inicio, @data_fim).order(data_hora_ida: :desc)
    garment_sewing_stock_exits = GarmentSewingStockExit.where('peca_costura_id IN (?)', garment_sewings.map(&:id))

    @dados = []
    garment_sewings.each do |garment_sewing|
      dados_costura = {}
      dados_costura[:costureira] = garment_sewing.costureira.nome
      dados_costura[:data_hora_ida] = garment_sewing.data_hora_ida.strftime('%d/%m/%Y')
      dados_costura[:data_hora_volta] = garment_sewing.data_hora_volta.strftime('%d/%m/%Y') unless garment_sewing.data_hora_volta.nil?
      dados_costura[:total_pecas_envio] = garment_sewing.total_pecas_envio.to_i
      dados_costura[:total_pecas_retorno] = garment_sewing.total_pecas_retorno.to_i if garment_sewing.total_pecas_retorno.to_i > 0
      @dados << dados_costura
    end
  end

  def set_dados_serigrafia
    garment_screen_printings = GarmentScreenPrinting.where('data_hora_ida >= ? AND data_hora_ida <= ?', @data_inicio, @data_fim).order(data_hora_ida: :desc)
    garment_screen_printing_stock_exits = GarmentScreenPrintingStockExit.where('peca_serigrafia_id IN (?)', garment_screen_printings.map(&:id))

    @dados = []
    garment_screen_printings.each do |garment_screen_printing|
      dados_serigrafia = {}
      dados_serigrafia[:serigrafia] = garment_screen_printing.serigrafia.nome
      dados_serigrafia[:data_hora_ida] = garment_screen_printing.data_hora_ida.strftime('%d/%m/%Y')
      dados_serigrafia[:data_hora_volta] = garment_screen_printing.data_hora_volta.strftime('%d/%m/%Y') unless garment_screen_printing.data_hora_volta.nil?
      dados_serigrafia[:total_pecas_envio] = garment_screen_printing.total_pecas_envio.to_i
      dados_serigrafia[:total_pecas_retorno] = garment_screen_printing.total_pecas_retorno.to_i if garment_screen_printing.total_pecas_retorno.to_i > 0
      @dados << dados_serigrafia
    end
  end

  def set_dados_acabamento
    garemnt_finishings = GarmentFinishing.where('data_hora_ida >= ? AND data_hora_ida <= ?', @data_inicio, @data_fim).order(data_hora_ida: :desc)
    garment_finishing_stock_exits = GarmentFinishingStockExit.where('peca_acabamento_id IN (?)', garemnt_finishings.map(&:id))

    @dados = []
    garemnt_finishings.each do |garemnt_finishing|
      dados_acabamento = {}
      dados_acabamento[:acabamento] = garemnt_finishing.acabamento.nome
      dados_acabamento[:data_hora_ida] = garemnt_finishing.data_hora_ida.strftime('%d/%m/%Y')
      dados_acabamento[:data_hora_volta] = garemnt_finishing.data_hora_volta.strftime('%d/%m/%Y') unless garemnt_finishing.data_hora_volta.nil?
      dados_acabamento[:total_pecas_envio] = garemnt_finishing.total_pecas_envio.to_i
      dados_acabamento[:total_pecas_retorno] = garemnt_finishing.total_pecas_retorno.to_i if garemnt_finishing.total_pecas_retorno.to_i > 0
      @dados << dados_acabamento
    end
  end
end

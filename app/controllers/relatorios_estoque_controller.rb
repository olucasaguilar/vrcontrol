class RelatoriosEstoqueController < ApplicationController
  def index; end

  def geral
    set_tecidos('ultimo')
    set_pecas('ultimo')
    set_pecas_acabadas('ultimo')
  
    pdf = Prawn::Document.new
  
    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10
  
    # Adicionando um título ao PDF
    pdf.text "Relatório de Estoque - Geral", size: 16, style: :bold
    pdf.move_down 10
  
    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12, align: :right
    pdf.move_down 10
  
    # Tabela para estoque de tecidos
    pdf.text "Estoque de Tecidos", size: 14, style: :bold
    pdf.move_down 5
    pdf.font_size 10
  
    table_data_tecidos = [["Tipo de Tecido", "Cor", "Quantidade em Quilos", "Última Atualização"]]
  
    @fabric_stock_groups.each do |(tipo_tecido, cor), fabric_stocks|
      fabric_stock = fabric_stocks.last # Pega o primeiro item do grupo
  
      formatted_saldo = "#{fabric_stock.saldo.to_s.gsub('.', ',')} kg"
  
      table_data_tecidos << [
        tipo_tecido,
        cor,
        formatted_saldo,
        fabric_stock.data_hora.strftime("%d/%m/%Y %H:%M")
      ]
    end

    if @fabric_stock_groups.empty?
      table_data_tecidos << [
        "Não há tecidos no estoque",
        "",
        "",
        ""
      ]
    end
  
    pdf.table(table_data_tecidos, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold
      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'
    end
  
    # Adiciona espaço entre as tabelas
    pdf.move_down 30
  
    # Tabela para peças
    pdf.text "Estoque de Peças", size: 14, style: :bold
    pdf.move_down 5
  
    # Lógica para obter os dados do estoque de peças e preencher a tabela
    
    # Criando uma tabela para a lista de estoque de peças
    table_data = [["Tipo de Peça", "Costurada", "Estampada", "Quantidade", "Última Atualização"]]

    @garment_stocks_groups.each do |(tipo_peca, costurada, estampada), garment_stocks|
      garment_stock = garment_stocks.last # Pega o primeiro item do grupo

      # Formatação manual dos valores como moeda brasileira
      formatted_saldo = "#{garment_stock.saldo.to_s.gsub('.', ',')} peças"

      table_data << [
        tipo_peca,
        costurada ? "Sim" : "Não",
        estampada ? "Sim" : "Não",
        formatted_saldo,
        garment_stock.data_hora.strftime("%d/%m/%Y %H:%M")
      ]
    end

    if @garment_stocks_groups.empty?
      table_data << [
        "Não há peças no estoque",
        "",
        "",
        "",
        ""
      ]
    end

    pdf.table(table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold

      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'
    end
  
    # Adiciona espaço entre as tabelas
    pdf.move_down 30
  
    # Tabela para peças acabadas
    pdf.text "Estoque de Peças Acabadas", size: 14, style: :bold
    pdf.move_down 5
  
    # Adicione aqui a lógica para obter os dados do estoque de peças acabadas e preencher a tabela
  
    # Criando uma tabela para a lista de estoque de peças acabadas
    table_data = [["Tipo de Peça", "Quantidade", "Última Atualização"]]

    @garment_stocks_finished_groups.each do |(tipo_peca), garment_stocks_finished|
      garment_stock_finished = garment_stocks_finished.last # Pega o primeiro item do grupo

      # Formatação manual dos valores como moeda brasileira
      formatted_saldo = "#{garment_stock_finished.saldo.to_s.gsub('.', ',')} peças"

      table_data << [
        tipo_peca,
        formatted_saldo,
        garment_stock_finished.data_hora.strftime("%d/%m/%Y %H:%M")
      ]
    end

    if @garment_stocks_finished_groups.empty?
      table_data << [
        "Não há peças acabadas no estoque",
        "",
        ""
      ]
    end

    pdf.table(table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold

      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_estoque.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def entrada_saida
    @tipo_objetos = {
      :tecido => 'Tecido',
      :peca => 'Peça',
      :peca_acabada => 'Peça Acabada'
    }
  end

  def entrada_saida_listagem    
    tipo_objeto = params[:tipo_objeto]
    @data_inicio = params[:data_inicio].to_datetime.change(hour: 0, minute: 0, second: 0)
    @data_fim = params[:data_fim].to_datetime.change(hour: 23, minute: 59, second: 59)
    
    #@financial_records = FinancialRecord.where("data_hora >= ? AND data_hora <= ?", @data_inicio, @data_fim).order(data_hora: :desc)
    if tipo_objeto == 'tecido'
      set_tecidos('historico')
      gerar_entrada_saida_tecidos
    elsif tipo_objeto == 'peca'
      set_pecas('historico')
      gerar_entrada_saida_pecas
    elsif tipo_objeto == 'peca_acabada'
      set_pecas_acabadas('historico')
      gerar_entrada_saida_pecas_acabadas
    end
  end

  private

  def gerar_entrada_saida_tecidos
    pdf = Prawn::Document.new
  
    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10
  
    # Adicionando um título ao PDF
    pdf.text "Relatório de Estoque - Histórico", size: 16, style: :bold
    pdf.move_down 10
  
    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12,
             size: 12, align: :right
    pdf.move_down 10
  
    # Tabela para estoque de tecidos
    pdf.text "Estoque de Tecidos", size: 14, style: :bold
    pdf.move_down 5
    pdf.font_size 10
  
    table_data_tecidos = [["Entrada/Saída", "Tipo de Tecido", "Cor", "Quantidade", "Saldo", "Data e Hora"]]

    @fabric_stock_groups.each do |(tipo_tecido, cor), fabric_stocks|
      fabric_stocks.each do |fabric_stock|
        formatted_quantidade = "#{fabric_stock.quantidade.to_s.gsub('.', ',')} kg"
        formatted_saldo = "#{fabric_stock.saldo.to_s.gsub('.', ',')} kg"
        table_data_tecidos << [
          fabric_stock.tipo_movimento,
          tipo_tecido,
          cor,
          formatted_quantidade,
          formatted_saldo,
          fabric_stock.data_hora.strftime("%d/%m/%Y %H:%M")
        ]
      end
    end

    if @fabric_stock_groups.empty?
      table_data_tecidos << [
        "Não há tecidos no estoque",
        "",
        "",
        "",
        "",
        ""
      ]
    end
  
    pdf.table(table_data_tecidos, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold
      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_estoque.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def gerar_entrada_saida_pecas
    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    pdf.text "Relatório de Estoque - Histórico", size: 16, style: :bold
    pdf.move_down 10

    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12,
              size: 12, align: :right
    pdf.move_down 10
    
    # Tabela para estoque de peças
    pdf.text "Estoque de Peças", size: 14, style: :bold
    pdf.move_down 5

    # Criando uma tabela para a lista de estoque de peças
    table_data = [["Entrada/Saída", "Tipo de Peça", "Costurada", "Estampada", "Quantidade", "Saldo", "Data e Hora"]]

    @garment_stocks_groups.each do |(tipo_peca, costurada, estampada), garment_stocks|
      garment_stocks.each do |garment_stock|
        formatted_quantidade = "#{garment_stock.quantidade.to_s.gsub('.', ',')}"
        formatted_saldo = "#{garment_stock.saldo.to_s.gsub('.', ',')}"

        table_data << [
          garment_stock.tipo_movimento,
          tipo_peca,
          costurada ? "Sim" : "Não",
          estampada ? "Sim" : "Não",
          formatted_quantidade,
          formatted_saldo,
          garment_stock.data_hora.strftime("%d/%m/%Y %H:%M")
        ]
      end
    end

    if @garment_stocks_groups.empty?
      table_data << [
        "Não há peças",
        "no estoque",
        "",
        "",
        "",
        "",
        ""
      ]
    end

    pdf.table(table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold
      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_estoque.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def gerar_entrada_saida_pecas_acabadas
    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    pdf.text "Relatório de Estoque - Histórico", size: 16, style: :bold
    pdf.move_down 10

    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12, align: :right
    pdf.move_down 10

    # Tabela para estoque de peças acabadas
    pdf.text "Estoque de Peças Acabadas", size: 14, style: :bold
    pdf.move_down 5

    # Criando uma tabela para a lista de estoque de peças acabadas
    table_data = [["Entrada/Saída", "Tipo de Peça", "Quantidade", "Saldo", "Data e Hora"]]

    @garment_stocks_finished_groups.each do |(tipo_peca), garment_stocks_finished|
      garment_stocks_finished.each do |garment_stock_finished|
        formatted_quantidade = "#{garment_stock_finished.quantidade.to_s.gsub('.', ',')}"
        formatted_saldo = "#{garment_stock_finished.saldo.to_s.gsub('.', ',')}"
        table_data << [
          garment_stock_finished.tipo_movimento,
          tipo_peca,
          formatted_quantidade,
          formatted_saldo,
          garment_stock_finished.data_hora.strftime("%d/%m/%Y %H:%M")
        ]

      end
    end

    if @garment_stocks_finished_groups.empty?
      table_data << [
        "Não há peças acabadas",
        "no estoque",
        "",
        "",
        ""
      ]
    end

    pdf.table(table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold
      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_estoque.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def set_tecidos(tipo)
    if tipo == 'historico'
      @fabric_stock_groups = FabricStock.where("data_hora >= ? AND data_hora <= ?", @data_inicio, @data_fim).order(data_hora: :desc).group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    else
      @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    end
    
    if tipo == 'ultimo'
      @fabric_stock_groups.each do |fabric_stock_group|
        last = fabric_stock_group[1].last      
        if last.saldo <= 0
          @fabric_stock_groups.delete(fabric_stock_group[0])
        end
      end
    end
    
    @fabric_types = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[1].last.tipo_tecido }.uniq
    @colors = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[1].last.cor }.uniq
    @fabric_stock_groups = @fabric_stock_groups.sort_by { |fabric_stock_group| fabric_stock_group[1].last.data_hora }.reverse
  end

  def set_pecas(tipo)
    if tipo == 'historico'
      @garment_stocks_groups = GarmentStock.where("data_hora >= ? AND data_hora <= ?", @data_inicio, @data_fim).order(data_hora: :desc).group_by { |garment_stock| [garment_stock.tipo_peca.nome, garment_stock.costurada, garment_stock.estampada] }
    else
      @garment_stocks_groups = GarmentStock.all.group_by { |garment_stock| [garment_stock.tipo_peca.nome, garment_stock.costurada, garment_stock.estampada] }
    end
    
    if tipo == 'ultimo'
      @garment_stocks_groups.each do |garment_stock_group|
        last = garment_stock_group[1].last
        if last.saldo <= 0
          @garment_stocks_groups.delete(garment_stock_group[0])
        end
      end
    end

    @garment_types = @garment_stocks_groups.map { |garment_stock_group| garment_stock_group[1].last.tipo_peca }.uniq    
    @garment_stocks_groups = @garment_stocks_groups.sort_by { |garment_stock_group| garment_stock_group[1].last.data_hora }.reverse    
  end

  def set_pecas_acabadas(tipo)
    if tipo == 'historico'
      @garment_stocks_finished_groups = GarmentFinishedStock.where("data_hora >= ? AND data_hora <= ?", @data_inicio, @data_fim).order(data_hora: :desc).group_by { |garment_finished_stock| [garment_finished_stock.tipo_peca.nome] }
    else
      @garment_stocks_finished_groups = GarmentFinishedStock.all.group_by { |garment_finished_stock| [garment_finished_stock.tipo_peca.nome] }
    end

    if tipo == 'ultimo'
      @garment_stocks_finished_groups.each do |garment_finished_stock_group|
        last = garment_finished_stock_group[1].last
        if last.saldo <= 0
          @garment_stocks_finished_groups.delete(garment_finished_stock_group[0])
        end
      end
    end

    @garment_types = @garment_stocks_finished_groups.map { |garment_finished_stock_group| garment_finished_stock_group[1].last.tipo_peca }.uniq
    @garment_stocks_finished_groups = @garment_stocks_finished_groups.sort_by { |garment_finished_stock_group| garment_finished_stock_group[1].last.data_hora }.reverse
  end
end

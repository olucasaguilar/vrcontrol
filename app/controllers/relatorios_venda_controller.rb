class RelatoriosVendaController < ApplicationController
  def index; end

  def entrada_saida; end

  def entrada_saida_listagem
    @data_inicio = params[:data_inicio].to_datetime.change(hour: 0, minute: 0, second: 0)
    @data_fim = params[:data_fim].to_datetime.change(hour: 23, minute: 59, second: 59)

    gerar_relatorio_entrada_saida
  end

  def gerar_relatorio_entrada_saida
    set_dados_vendas
    
    # Criando o PDF
    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    pdf.text "Relatório de Vendas - Peças", size: 16, style: :bold
    pdf.move_down 10

    # Adding the date
    pdf.text "Data de Impressão: #{Time.now.strftime("%d/%m/%Y %H:%M")}", size: 12,
    size: 12, align: :right

    # Período de consulta
    pdf.text "Período de Consulta: #{@data_inicio.strftime("%d/%m/%Y")} até #{@data_fim.strftime("%d/%m/%Y")}"
    pdf.move_down 10
    
    # Criando uma tabela para os dados de vendas
    sales_table_data = [
      ["Vendedor", "Total Saída", "Total Retorno", "Total Final"]
    ]

    @dados.each do |dado|
      sales_table_data << [
        dado[:vendedor],
        dado[:total_saida],
        dado[:total_retorno],
        dado[:total_saida] - dado[:total_retorno]
      ]
    end

    pdf.table(sales_table_data, header: true, width: pdf.bounds.width, row_colors: ['F3F3F3', 'FFFFFF']) do
      row(0).font_style = :bold

      cells.borders = [:top, :bottom]
      cells.border_width = 0.5
      cells.padding = 5
      cells.valign = :middle
      row(0).background_color = 'DDDDDD'

      # Ajustando a largura das colunas
      columns(0).width = pdf.width_of("Vendedor", size: 40)
    end

    # Enviando os dados do PDF
    send_data(pdf.render,
              filename: 'relatorio_vendas.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def set_dados_vendas  
    @dados = []
    garment_sales = GarmentSaleExit.where('data_hora >= ? AND data_hora <= ?', @data_inicio, @data_fim).order(data_hora: :desc)
    garment_sales.each do |garment_sale|
      registro = {
        vendedor: garment_sale.vendedor.nome,
        total_saida: garment_sale.total_pecas.to_i,
        total_retorno: 0
      }
      if vendedor_ja_existe = @dados.find { |dado| dado[:vendedor] == registro[:vendedor] }
        vendedor_ja_existe[:total_saida] += registro[:total_saida]
      else
        @dados << registro
      end
    end
  
    garment_sales_returns = GarmentSaleReturn.where('data_hora >= ? AND data_hora <= ?', @data_inicio, @data_fim).order(data_hora: :desc)
    garment_sales_returns.each do |garment_sale_return|
      vendedor = garment_sale_return.vendedor.nome
      garment_stock_entries = GarmentStockEntry.where(peca_venda_retorno: garment_sale_return)
      garment_stock_entries.each do |garment_stock_entry|
        @dados.each do |dado|
          if dado[:vendedor] == vendedor
            dado[:total_retorno] += garment_stock_entry.saida_peca_acabada.quantidade
          end
        end
      end
    end
  end
end
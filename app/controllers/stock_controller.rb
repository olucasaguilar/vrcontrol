class StockController < ApplicationController
  before_action :verify_fabric_stock, only: [:tecidos_view]
  before_action :verify_garment_stock, only: [:pecas_view]
  before_action :verify_finished_garment_stock, only: [:pecas_acabadas_view]

  def tecidos_view
    flash[:notice] = []

    @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    
    @fabric_stock_groups.each do |fabric_stock_group|
      last = fabric_stock_group[1].last
      
      if last.saldo <= 0
        @fabric_stock_groups.delete(fabric_stock_group[0])
      end
    end

    @fabric_types = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[1].last.tipo_tecido }.uniq
    @colors = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[1].last.cor }.uniq

    @fabric_stock_groups.each do |fabric_stock_group|
      last = fabric_stock_group[1].last

      if params[:tipo_tecido_id].present?
        if last.tipo_tecido_id != params[:tipo_tecido_id].to_i
          @fabric_stock_groups.delete(fabric_stock_group[0])
        end
      end

      if params[:cor_id].present?
        if last.cor_id != params[:cor_id].to_i
          @fabric_stock_groups.delete(fabric_stock_group[0])
        end
      end
    end

    @fabric_stock_groups = @fabric_stock_groups.sort_by { |fabric_stock_group| fabric_stock_group[1].last.data_hora }.reverse
  end

  def pecas_view
    flash[:notice] = []

    @garment_stocks_groups = GarmentStock.all.group_by { |garment_stock| [garment_stock.tipo_peca.nome, garment_stock.costurada, garment_stock.estampada] }
    
    @garment_stocks_groups.each do |garment_stock_group|
      last = garment_stock_group[1].last

      if last.saldo <= 0
        @garment_stocks_groups.delete(garment_stock_group[0])
      end
    end

    @garment_types = @garment_stocks_groups.map { |garment_stock_group| garment_stock_group[1].last.tipo_peca }.uniq

    @garment_stocks_groups.each do |garment_stock_group|
      last = garment_stock_group[1].last

      if params[:costurada] == "1" && last.costurada == false
        @garment_stocks_groups.delete(garment_stock_group[0])
      elsif params[:costurada] == "0" && last.costurada == true
        @garment_stocks_groups.delete(garment_stock_group[0])
      end

      if params[:estampada] == "1" && last.estampada == false
        @garment_stocks_groups.delete(garment_stock_group[0])
      elsif params[:estampada] == "0" && last.estampada == true
        @garment_stocks_groups.delete(garment_stock_group[0])
      end

      if params[:tipo_peca_id].present?
        if last.tipo_peca_id != params[:tipo_peca_id].to_i
          @garment_stocks_groups.delete(garment_stock_group[0])
        end
      end
    end
    
    @garment_stocks_groups = @garment_stocks_groups.sort_by { |garment_stock_group| garment_stock_group[1].last.data_hora }.reverse    
  end

  def pecas_acabadas_view
    flash[:notice] = []

    @garment_stocks_finished_groups = GarmentFinishedStock.all.group_by { |garment_finished_stock| [garment_finished_stock.tipo_peca.nome] }

    @garment_stocks_finished_groups.each do |garment_finished_stock_group|
      last = garment_finished_stock_group[1].last

      if last.saldo <= 0
        @garment_stocks_finished_groups.delete(garment_finished_stock_group[0])
      end
    end

    @garment_types = @garment_stocks_finished_groups.map { |garment_finished_stock_group| garment_finished_stock_group[1].last.tipo_peca }.uniq

    @garment_stocks_finished_groups.each do |garment_finished_stock_group|
      last = garment_finished_stock_group[1].last

      if params[:tipo_peca_id].present?
        if last.tipo_peca_id != params[:tipo_peca_id].to_i
          @garment_stocks_finished_groups.delete(garment_finished_stock_group[0])
        end
      end
    end

    @garment_stocks_finished_groups = @garment_stocks_finished_groups.sort_by { |garment_finished_stock_group| garment_finished_stock_group[1].last.data_hora }.reverse
  end

  def tecidos_report
    tecidos_view

    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10
  
    # Adicionando um título ao PDF
    pdf.text "Relatório de Estoque de Tecidos", size: 16, style: :bold
    pdf.move_down 10

    # Adding a subtitle to the PDF
    pdf.text "Filtros:", size: 12, style: :bold
    #
    if FabricType.where(id: params[:tipo_tecido_id]).first.nil?
      pdf.text "Tipo de Tecido: #{params[:tipo_tecido_id]}", size: 12
    else
      pdf.text "Tipo de Tecido: #{FabricType.where(id: params[:tipo_tecido_id]).first.nome}", size: 12
    end
    #
    if Color.where(id: params[:cor_id]).first.nil?
      pdf.text "Cor: #{params[:cor_id]}", size: 12
    else
      pdf.text "Cor: #{Color.where(id: params[:cor_id]).first.nome}", size: 12
    end
    pdf.move_down 10
  
    # Criando uma tabela para a lista de estoque de tecidos
    table_data = [["Tipo de Tecido", "Cor", "Quantidade em Quilos", "Última Atualização"]]
  
    @fabric_stock_groups.each do |(tipo_tecido, cor), fabric_stocks|
      fabric_stock = fabric_stocks.first # Pega o primeiro item do grupo
  
      # Formatação manual dos valores como moeda brasileira
      formatted_saldo = "#{fabric_stock.saldo.to_s.gsub('.', ',')} kg"
  
      table_data << [
        tipo_tecido,
        cor,
        formatted_saldo,
        fabric_stock.data_hora.strftime("%d/%m/%Y %H:%M")
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
              filename: 'relatorio_estoque_tecidos.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def pecas_report
    pecas_view

    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    pdf.text "Relatório de Estoque de Peças", size: 16, style: :bold
    pdf.move_down 10

    # Adding a subtitle to the PDF
    pdf.text "Filtros:", size: 12, style: :bold
    #
    if GarmentType.where(id: params[:tipo_peca_id]).first.nil?
      pdf.text "Tipo de Peça: #{params[:tipo_peca_id]}", size: 12
    else
      pdf.text "Tipo de Peça: #{GarmentType.where(id: params[:tipo_peca_id]).first.nome}", size: 12
    end
    #
    if params[:costurada] == "1"
      pdf.text "Costurada: Sim", size: 12
    elsif params[:costurada] == "0"
      pdf.text "Costurada: Não", size: 12
    end
    #
    if params[:estampada] == "1"
      pdf.text "Estampada: Sim", size: 12
    elsif params[:estampada] == "0"
      pdf.text "Estampada: Não", size: 12
    end
    pdf.move_down 10

    # Criando uma tabela para a lista de estoque de peças
    table_data = [["Tipo de Peça", "Costurada", "Estampada", "Quantidade", "Última Atualização"]]

    @garment_stocks_groups.each do |(tipo_peca, costurada, estampada), garment_stocks|
      garment_stock = garment_stocks.first # Pega o primeiro item do grupo

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
              filename: 'relatorio_estoque_pecas.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  def pecas_acabadas_report
    pecas_acabadas_view

    pdf = Prawn::Document.new

    # Adicionando o título do sistema
    pdf.text "VR Control", size: 24, style: :bold, align: :center
    pdf.move_down 10

    # Adicionando um título ao PDF
    pdf.text "Relatório de Estoque de Peças Acabadas", size: 16, style: :bold
    pdf.move_down 10

    # Adding a subtitle to the PDF
    pdf.text "Filtros:", size: 12, style: :bold
    #
    if GarmentType.where(id: params[:tipo_peca_id]).first.nil?
      pdf.text "Tipo de Peça: #{params[:tipo_peca_id]}", size: 12
    else
      pdf.text "Tipo de Peça: #{GarmentType.where(id: params[:tipo_peca_id]).first.nome}", size: 12
    end
    pdf.move_down 10

    # Criando uma tabela para a lista de estoque de peças acabadas
    table_data = [["Tipo de Peça", "Quantidade", "Última Atualização"]]

    @garment_stocks_finished_groups.each do |(tipo_peca), garment_stocks_finished|
      garment_stock_finished = garment_stocks_finished.first # Pega o primeiro item do grupo

      # Formatação manual dos valores como moeda brasileira
      formatted_saldo = "#{garment_stock_finished.saldo.to_s.gsub('.', ',')} peças"

      table_data << [
        tipo_peca,
        formatted_saldo,
        garment_stock_finished.data_hora.strftime("%d/%m/%Y %H:%M")
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
              filename: 'relatorio_estoque_pecas_acabadas.pdf',
              type: 'application/pdf',
              disposition: 'inline')
  end

  private

  def verify_fabric_stock
    unless current_user.user_permission.fabric_stock || current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end

  def verify_garment_stock
    unless current_user.user_permission.garment_stock || current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end

  def verify_finished_garment_stock
    unless current_user.user_permission.finished_garment_stock || current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end
end


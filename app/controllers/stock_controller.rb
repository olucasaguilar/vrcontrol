class StockController < ApplicationController
  def tecidos_view
    @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    @colors = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
    @fabric_types = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][0] }.uniq
  end

  def pecas_view
  end
end

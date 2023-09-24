class StockController < ApplicationController
  def index
    @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
  end

  def temp_view
  end
end

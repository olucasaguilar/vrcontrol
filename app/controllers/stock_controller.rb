class StockController < ApplicationController
  def tecidos_view
    @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    
    @fabric_stock_groups.each do |fabric_stock_group|
      last_saldo = fabric_stock_group[1].last.saldo
      if last_saldo <= 0
        @fabric_stock_groups.delete(fabric_stock_group[0])
      end
    end

    @fabric_stock_groups
    @colors = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
    @fabric_types = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][0] }.uniq
  end

  def pecas_view
    flash[:notice] = []

    #@garment_types_groups = GarmentType.all

    @garment_stocks_groups = GarmentStock.all.group_by { |garment_stock| [garment_stock.tipo_peca.nome, garment_stock.costurada, garment_stock.estampada] }
    @garment_stocks_groups.each do |garment_stock_group|
      last_saldo = garment_stock_group[1].last.saldo
      if last_saldo <= 0
        @garment_stocks_groups.delete(garment_stock_group[0])
      end
    end
    
  end
end

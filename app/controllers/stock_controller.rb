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

    @garment_types_groups = GarmentType.all

    # #<GarmentStock id: 1, tipo_peca_id: 1, costurada: false, estampada: false, quantidade: 44, tipo_movimento: "Entrada", data_hora: "2023-10-27 21:14:37.000000000 +0000", saldo: 44, created_at: "2023-10-28 00:16:00.345818000 +0000", updated_at: "2023-10-28 00:16:00.345818000 +0000">
    @garment_stocks_groups = GarmentStock.all.group_by { |garment_stock| [garment_stock.tipo_peca.nome, garment_stock.costurada, garment_stock.estampada] }
    
  end
end

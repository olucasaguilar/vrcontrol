class StockController < ApplicationController
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
end

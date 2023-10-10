class FabricCutsController < ApplicationController
  def new
    if (FabricCut.any? && (FabricCut.last.finalizado == false))
      redirect_to new_fabric_cut_details_path
    else
      data_hora = Time.now - 3.hour
      busca_cortadores()
      @fabric_cut = FabricCut.new
      @fabric_cut.data_hora_ida = data_hora   
      @financial_records = []
    end
  end

  def create
    @fabric_cut = FabricCut.new(fabric_cut_params)
    @fabric_cut.finalizado = false
    @financial_records = []
    all_valid = true

    unless params[:valor].nil?
      params[:valor].each_with_index do |valor, index|
        tipo_movimento = 'Saída'
        observacao = params[:observacao][index]
        data_hora = @fabric_cut.data_hora_ida
        @financial_records << FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
      end
      
      @financial_records.each do |financial_record|
        unless financial_record.valid?
          all_valid = false
        end      
      end
    end

    if @fabric_cut.valid? && all_valid
      flash[:notice] = []
      @fabric_cut.save
      
      @financial_records.each do |financial_record|
        observacao_original = financial_record.observacao
        pre_msg = 'Corte - Envio'
        pre_msg += ' - ' unless observacao_original.blank?
        financial_record.observacao = pre_msg + financial_record.observacao
        financial_record.save

        financial_fabric_cut = FinancialFabricCut.new(
          registro_financeiro: financial_record,
          tecido_corte: @fabric_cut,
          retorno: false
        )

        if financial_fabric_cut.valid?
          financial_fabric_cut.save
          # Temp
          flash[:notice] << 'Vinculo entre movimentação de caixa e tecido ao corte criado com sucesso!'
        else
          flash[:notice] << 'Erro ao criar o vinculo entre movimentação de caixa e tecido ao corte!'
        end
      end
      # Temp
      if @financial_records.any?
        flash[:notice] << 'Movimentação de caixa criada com sucesso!'
      end

      flash[:notice] << 'Envio ao corte criado com sucesso!'
      redirect_to new_fabric_cut_details_path
    else
      busca_cortadores()
      render :new
    end
  end

  def new_details
    unless (FabricCut.any? && (FabricCut.last.finalizado == false))
      redirect_to new_fabric_cut_path
    else
      @tecido = {
        fabric_type_id: 0,
        color_id: 0,
        quantidade: 0,
        garment_type_id: 0,
        multiplicador_x: 4.6,
        rendimento: 0
      }

      @tecidos = []
      # @fabric_stock_errors = []
      session.delete(:tecidos)
      session[:tecidos] ||= []
      
      @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
      @fabric_stock_groups.each do |fabric_stock_group|
        last_saldo = fabric_stock_group[1].last.saldo
        if last_saldo <= 0
          @fabric_stock_groups.delete(fabric_stock_group[0])
        end
      end

      colors_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
      fabric_types_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][0] }.uniq

      @fabric_types = FabricType.where(nome: fabric_types_estoque)
      @colors = Color.where(nome: colors_estoque)
      @garment_types = GarmentType.all      
    end
  end

  def quantity_to_float(quantity)
    # "15,66" => 15.66
    quantity = quantity.gsub(',', '.')
    quantity.to_f
  end

  def create_details
    @fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    @fabric_stock_groups.each do |fabric_stock_group|
      last_saldo = fabric_stock_group[1].last.saldo
      if last_saldo <= 0
        @fabric_stock_groups.delete(fabric_stock_group[0])
      end
    end

    colors_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
    fabric_types_estoque = @fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][0] }.uniq

    @fabric_types = FabricType.where(nome: fabric_types_estoque)
    @colors = Color.where(nome: colors_estoque)
    @garment_types = GarmentType.all      

    @tecidos = []
    button = params[:commit]
    flash[:notice] = []
    #flash[:notice] = params[:commit]

    if button == 'Adicionar' || button == 'Remover' || button == 'Finalizar'
      session[:tecidos].each do |tecido_session|
        tecido = {
          fabric_type_id: tecido_session["fabric_type_id"],
          color_id: tecido_session["color_id"],
          quantidade: tecido_session["quantidade"],
          garment_type_id: tecido_session["garment_type_id"],
          multiplicador_x: tecido_session["multiplicador_x"],
          rendimento: tecido_session["rendimento"]
        }      
        @tecidos << tecido
      end

      if button == 'Adicionar'
        tecido_validar = {
          fabric_type_id: params[:tecido][:fabric_type_id],
          color_id: params[:tecido][:color_id],
          quantidade: params[:tecido][:quantidade],
          garment_type_id: params[:tecido][:garment_type_id],
          multiplicador_x: params[:tecido][:multiplicador_x],
          rendimento: params[:tecido][:rendimento]
        }

        tecido_validar[:quantidade] = quantity_to_float(tecido_validar[:quantidade])

        if validate_tecido(tecido_validar)
          session[:tecidos] << tecido_validar
          @tecidos << tecido_validar
        else
          @tecido = tecido_validar
        end
      elsif button == 'Remover'
        index_tecido = params[:tecido_index].to_i
        session[:tecidos].delete_at(index_tecido)
        @tecidos.delete_at(index_tecido)
      elsif button == 'Finalizar'
        if @tecidos.any?
          # session.delete(:tecidos)
          # session[:tecidos] ||= []
          save_tecidos(@tecidos)
          flash[:notice] << 'Envio ao corte finalizado com sucesso!'
          redirect_to root_path and return
        else
          flash[:alert] = 'Nenhum tecido adicionado!'
        end
      end
    end

    if @tecido.nil?
      @tecido = {
        fabric_type_id: 0,
        color_id: 0,
        quantidade: 0,
        garment_type_id: 0,
        multiplicador_x: 4.6,
        rendimento: 0
      }
    end

    render :new_details
    #redirect_to new_fabric_cut_details_path
  end

  def save_tecidos(tecidos)
    flash[:notice] = []
    #flash[:notice] << tecidos.inspect
    #flash[:notice] << 'teste'
    # exemplo
    # [{:fabric_type_id=>"1", :color_id=>"1", :quantidade=>1.0, :garment_type_id=>"1", :multiplicador_x=>"4.6", :rendimento=>"4.60"}, {:fabric_type_id=>"2", :color_id=>"2", :quantidade=>5.0, :garment_type_id=>"1", :multiplicador_x=>"4.6", :rendimento=>"23.00"}]
    tecidos.each do |tecido|
      fabric_stock = FabricStock.new
      fabric_stock.tipo_tecido_id = tecido[:fabric_type_id]
      fabric_stock.cor_id = tecido[:color_id]
      fabric_stock.quantidade = tecido[:quantidade]
      fabric_stock.tipo_movimento = 'Saida'
      fabric_stock.data_hora = FabricCut.last.data_hora_ida
      flash[:notice] << "Saida invalida" unless fabric_stock.valid?
      fabric_stock.save

      fabric_stock_exit = FabricStockExit.new
      fabric_stock_exit.tecido_corte = FabricCut.last
      fabric_stock_exit.estoque_tecido = fabric_stock
      fabric_stock_exit.multiplicador = tecido[:multiplicador_x]
      fabric_stock_exit.rendimento = tecido[:rendimento]
      fabric_stock_exit.tipo_peca_id = tecido[:garment_type_id]
      flash[:notice] << "Vinculo invalido" unless fabric_stock_exit.valid?
      fabric_stock_exit.save
    end

    FabricCut.last.update(finalizado: true)
    FabricCut.last.update(total_tecido_envio: tecidos.sum { |tecido| tecido[:quantidade].to_f })
  end

  def get_colors_for_fabric_type    
    session.delete(:color_id)
    session[:color_id] ||= []

    fabric_type_id = params[:fabric_type_id]

    fabric_stock_groups = FabricStock.all.group_by { |fabric_stock| [fabric_stock.tipo_tecido.nome, fabric_stock.cor.nome] }
    fabric_stock_groups.each do |fabric_stock_group|
      last_saldo = fabric_stock_group[1].last.saldo
      if last_saldo <= 0
        fabric_stock_groups.delete(fabric_stock_group[0])
      end
      if fabric_stock_group[0][0] != FabricType.find(fabric_type_id).nome
        fabric_stock_groups.delete(fabric_stock_group[0])
      end
    end

    colors_estoque = fabric_stock_groups.map { |fabric_stock_group| fabric_stock_group[0][1] }.uniq
    colors = Color.where(nome: colors_estoque)
    colors = colors.map { |color| { id: color.id, nome: color.nome } }
    colors = colors.uniq { |color| color[:id] }

    session.delete(:fabric_type_id)
    session[:fabric_type_id] ||= []
    session[:fabric_type_id] << fabric_type_id

    render json: { colors: colors }
  end

  def get_total_quantity_for_color
    color_id = params[:color_id]
    fabric_type_id = session[:fabric_type_id].last
    total_quantity = FabricStock.where(tipo_tecido_id: fabric_type_id, cor_id: color_id).last
    render json: { total_quantity: total_quantity.saldo }
  end

  def validate_tecido(tecido)
    fabric_stock = FabricStock.new

    fabric_stock.tipo_tecido_id = tecido[:fabric_type_id]
    fabric_stock.cor_id = tecido[:color_id]
    fabric_stock.quantidade = tecido[:quantidade]
    fabric_stock.tipo_movimento = 'Saida'
    fabric_stock.data_hora = FabricCut.last.data_hora_ida
    flash[:notice] = []
    flash[:alert] = []
    #flash[:notice] << s
    

    validation = true

    unless fabric_stock.valid?
      @fabric_stock_errors = fabric_stock.errors
      validation = false
    end

    fabric_stock_exit = FabricStockExit.new
    fabric_stock_exit.tecido_corte = FabricCut.last
    fabric_stock_exit.estoque_tecido = fabric_stock
    fabric_stock_exit.tipo_peca_id = tecido[:garment_type_id]    
    validation = false unless fabric_stock_exit.valid?
    @fabric_stock_exit_errors = fabric_stock_exit.errors
    #flash[:notice] << @fabric_stock_exit_errors.full_messages

    unless validation
      session.delete(:color_id)
      session[:color_id] ||= []
      session[:color_id] << tecido[:color_id]
    end
    
    validation
  end

  def return
    @fabric_cuts = FabricCut.where(data_hora_volta: nil)
  end

  def return_details
    @garment_sizes = GarmentSize.all
    @lote_tamanhos = []
    @financial = {
      valor: nil,
      observacao: ''
    }

    @financial_extra = []
      

    fabric_cut = FabricCut.find(params[:id])
    data_hora_volta = Time.now - 3.hour
    fabric_stock_exits = FabricStockExit.where(tecido_corte: fabric_cut)

    @lote = {
      tecido_corte: fabric_cut,
      data_hora_volta: data_hora_volta,
      fabric_stock_exits: []
    }

    fabric_stock_exits.each_with_index do |fabric_stock_exit, index|
      @lote_tamanhos << {}
      @lote[:fabric_stock_exits] << {
        tipo_tecido: fabric_stock_exit.estoque_tecido.tipo_tecido.nome,
        cor: fabric_stock_exit.estoque_tecido.cor.nome,
        quantidade: fabric_stock_exit.estoque_tecido.quantidade,
        tipo_peca: fabric_stock_exit.tipo_peca.nome,
        pecas: 0,
        tamanhos: false,
      }
    end
  end

  def create_fabric_cut_return    
    all_valid = false
    flash[:notice] = []
    button = params[:commit]
    button = 'Remover' unless params[:remove_button].nil?
    #flash[:notice] << button

    @garment_sizes = GarmentSize.all
    @lote_tamanhos = []
    unless params['financial'].nil?
      @financial = {
        valor: params['financial']['valor'],
        observacao: params['financial']['obs']
      }
    else
      @financial = {
        valor: nil,
        observacao: ''
      }
    end

    # params['financial_extra'] => "financial_extra"=>{"0"=>{"valor"=>"", "obs"=>"aaaaa"}}
    @financial_extra = []
    unless params['financial_extra'].nil?
      params['financial_extra'].each do |key, value|
        @financial_extra << {
          valor: value['valor'],
          observacao: value['obs']
        }
      end
    end

    fabric_cut = FabricCut.find(params[:fabric_cut_id])
    data_hora_volta = params[:data_hora_volta].to_datetime
    fabric_stock_exits = FabricStockExit.where(tecido_corte: fabric_cut)

    @lote = {
      tecido_corte: fabric_cut,
      data_hora_volta: data_hora_volta,
      fabric_stock_exits: []
    }

    fabric_stock_exits.each_with_index do |fabric_stock_exit, index|
      unless params[:tam].nil?
        unless params[:tam]["#{index}"].nil?
          #flash[:notice] << params[:tam]["#{index}"]
          tamanhos = params[:tam]["#{index}"]
          @lote_tamanhos << tamanhos
        else
          @lote_tamanhos << {}
        end
      else
        @lote_tamanhos << {}
      end      

      tamanho = false

      unless params[:tamanhos].nil?
        tamanho = true if params[:tamanhos]["#{index}"] == 'true'
      end
      
      @lote[:fabric_stock_exits] << {
        tipo_tecido: fabric_stock_exit.estoque_tecido.tipo_tecido.nome,
        cor: fabric_stock_exit.estoque_tecido.cor.nome,
        quantidade: fabric_stock_exit.estoque_tecido.quantidade,
        tipo_peca: fabric_stock_exit.tipo_peca.nome,
        pecas: params[:pecas]["#{index}"].to_i,
        tamanho: tamanho,
      }
    end

    if button == 'Remover'
      financial_extra_index = params[:remove_button].keys.first.to_i
      @financial_extra.delete_at(financial_extra_index)
    elsif button == 'Adicionar Valor Extra'
      if financial_validate(@financial, @lote[:data_hora_volta])
        @financial_extra << @financial.clone
        @financial = {
          valor: nil,
          observacao: ''
        }
      end
    else
      # 
      # @lote
      # @lote_tamanhos
      # @financial ///
      # @financial_extra ///
      # 
      all_valid = true
      all_valid = false unless financial_validate(@financial, @lote[:data_hora_volta])
    end
    
    #temp
    flash[:notice] << all_valid
    all_valid = false

    unless all_valid
      render :return_details and return
    else
      # salva tudo
      # render de confirmação
    end
  end

  def financial_validate(financial, data_hora)
    financial_record = FinancialRecord.new(valor: financial[:valor], tipo_movimento: 'Entrada', observacao: financial[:observacao], data_hora: data_hora)
    financial_record.valid?
    #@financial_errors = financial_record.errors
    @financial_errors = financial_record.errors
    financial_record.valid?
  end

  private

  def busca_cortadores
    entity_type_cortador = EntityType.find_by(nome: 'Cortador')
    @cortadores = Entity.where(entity_type: entity_type_cortador)
  end

  def fabric_cut_params
    params.require(:fabric_cut).permit(:data_hora_ida, :cortador_id)
  end
end

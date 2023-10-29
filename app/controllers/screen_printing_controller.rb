class ScreenPrintingController < ApplicationController
  def new
    if (GarmentScreenPrinting.any? && (GarmentScreenPrinting.last.finalizado == false))
      redirect_to new_screen_printing_details_path
    else
      data_hora = Time.now - 3.hour
      busca_entidades
      @garment_screen_printing = GarmentScreenPrinting.new
      @garment_screen_printing.data_hora_ida = data_hora   
      @financial_records = []
    end
  end

  def create
    @garment_screen_printing = GarmentScreenPrinting.new(data_hora_ida: params[:garment_screen_printing][:data_hora_ida], serigrafia_id: params[:garment_screen_printing][:entidade_id])
    @garment_screen_printing.finalizado = false
    @financial_records = []
    all_valid = true

    unless params[:valor].nil?
      params[:valor].each_with_index do |valor, index|
        tipo_movimento = 'Saída'
        observacao = params[:observacao][index]
        data_hora = @garment_screen_printing.data_hora_ida
        @financial_records << FinancialRecord.new(valor: valor, tipo_movimento: tipo_movimento, observacao: observacao, data_hora: data_hora)
      end
      
      @financial_records.each do |financial_record|
        unless financial_record.valid?
          all_valid = false
        end      
      end
    end

    if @garment_screen_printing.valid? && all_valid
      flash[:notice] = []
      @garment_screen_printing.save
      
      @financial_records.each do |financial_record|
        observacao_original = financial_record.observacao
        pre_msg = 'Serigrafia - Envio'
        pre_msg += ' - ' unless observacao_original.blank?
        financial_record.observacao = pre_msg + financial_record.observacao
        financial_record.save

        financial_garment_screens = FinancialGarmentScreens.new(
          registro_financeiro: financial_record,
          peca_serigrafia: @garment_screen_printing,
          retorno: false
        )

        if financial_garment_screens.valid?
          financial_garment_screens.save
          # Temp
          flash[:notice] << 'Vinculo entre movimentação de caixa e tecido à serigrafia criado com sucesso!'
        else
          flash[:notice] << 'Erro ao criar o vinculo entre movimentação de caixa e tecido à serigrafia!'
        end
      end
      # Temp
      if @financial_records.any?
        flash[:notice] << 'Movimentação de caixa criada com sucesso!'
      end

      flash[:notice] << 'Envio à Serigrafia criado com sucesso!'
      redirect_to new_screen_printing_details_path
    else
      busca_entidades
      render :new
    end
  end

  def new_details
    #
  end

  def create_details
    #
  end

  def return
    #
  end

  def return_details
    #
  end

  def create_screen_printing_return
    #
  end

  private

  def busca_entidades
    entity_type = EntityType.find_by(nome: 'Serigrafia')
    @entidades = Entity.where(entity_type: entity_type)
  end
end

# get '/serigrafia/envio', to: 'screen_printing#new', as: 'new_screen_printing'
# post '/serigrafia/envio', to: 'screen_printing#create', as: 'create_screen_printing'

# get '/serigrafia/envio/detalhes', to: 'screen_printing#new_details', as: 'new_screen_printing_details'
# post '/serigrafia/envio/detalhes', to: 'screen_printing#create_details', as: 'create_screen_printing_details'

# get '/serigrafia/retorno', to: 'screen_printing#return', as: 'return_screen_printing'

# get '/serigrafia/retorno/:id', to: 'screen_printing#return_details', as: 'return_screen_printing_details'
# post '/serigrafia/retorno', to: 'screen_printing#create_screen_printing_return', as: 'create_screen_printing_return'
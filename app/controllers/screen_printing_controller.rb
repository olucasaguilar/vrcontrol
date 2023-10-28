class ScreenPrintingController < ApplicationController
  def new
    # if (FabricCut.any? && (FabricCut.last.finalizado == false))
    #   redirect_to new_fabric_cut_details_path
    # else
    #   data_hora = Time.now - 3.hour
    #   busca_cortadores()
    #   @fabric_cut = FabricCut.new
    #   @fabric_cut.data_hora_ida = data_hora   
    #   @financial_records = []
    # end
  end

  def create
  end

  def new_details
  end

  def create_details
  end

  def return
  end

  def return_details
  end

  def create_screen_printing_return
  end
end

# get '/serigrafia/envio', to: 'screen_printing#new', as: 'new_screen_printing'
# post '/serigrafia/envio', to: 'screen_printing#create', as: 'create_screen_printing'

# get '/serigrafia/envio/detalhes', to: 'screen_printing#new_details', as: 'new_screen_printing_details'
# post '/serigrafia/envio/detalhes', to: 'screen_printing#create_details', as: 'create_screen_printing_details'

# get '/serigrafia/retorno', to: 'screen_printing#return', as: 'return_screen_printing'

# get '/serigrafia/retorno/:id', to: 'screen_printing#return_details', as: 'return_screen_printing_details'
# post '/serigrafia/retorno', to: 'screen_printing#create_screen_printing_return', as: 'create_screen_printing_return'
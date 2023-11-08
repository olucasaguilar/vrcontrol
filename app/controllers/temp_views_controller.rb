class TempViewsController < ApplicationController
  def venda_saida
  end

  def venda_retorno
    @venda_retorno = 'venda_retorno'
  end
end

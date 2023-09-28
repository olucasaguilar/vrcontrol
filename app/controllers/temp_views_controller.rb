class TempViewsController < ApplicationController
  def corte_envio
  end

  def corte_retorno
    @corte_retorno = 'corte retorno teste'
  end

  def serigrafia
    @serigrafia = 'serigrafia teste'
  end

  def costura
    @costura = 'costura teste'
  end

  def acabamento
    @acabamento = 'acabamento teste'
  end

  def venda
    @venda = 'venda teste'
  end

  def login
  end
end

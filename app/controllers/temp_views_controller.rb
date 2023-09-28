class TempViewsController < ApplicationController
  def corte_envio
  end

  def corte_retorno
  end

  def serigrafia_envio
    @serigrafia_envio = 'serigrafia_envio'
  end

  def serigrafia_retorno
    @serigrafia_retorno = 'serigrafia_retorno'
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

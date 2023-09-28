class TempViewsController < ApplicationController
  def corte_envio
  end

  def corte_retorno
  end

  def serigrafia_envio
  end

  def serigrafia_retorno
  end

  def costura_envio
  end

  def costura_retorno
  end

  def acabamento_envio
  end

  def acabamento_retorno
    @acabamento_retorno = 'acabamento_retorno teste'
  end

  def venda
    @venda = 'venda teste'
  end

  def login
  end
end

class TempViewsController < ApplicationController
  def costura_envio
  end

  def costura_retorno
  end

  def acabamento_envio
  end

  def acabamento_retorno
    @acabamento_retorno = 'acabamento_retorno teste'
  end

  def venda_saida
  end

  def venda_retorno
    @venda_retorno = 'venda_retorno'
  end

  def login
  end
end

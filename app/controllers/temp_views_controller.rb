class TempViewsController < ApplicationController
  def corte_ida
    @corte_ida = 'corte ida teste'
  end

  def corte_volta
    @corte_volta = 'corte volta teste'
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

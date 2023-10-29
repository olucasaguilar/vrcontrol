class SharedController < ApplicationController
  def generic_new(variables)
    if (variables[:model].any? && (variables[:model].last.finalizado == false))
      redirect_to variables[:redirect_path]
    else
      data_hora = Time.now - 3.hours
      busca_entidades
      instance_variable_set("@#{variables[:model_name]}", variables[:model].new)
      instance_variable_get("@#{variables[:model_name]}").data_hora_ida = data_hora
      @financial_records = []
    end
  end
end

class ExtrasController < ApplicationController
  before_action :verify_extras

  private

  def verify_extras
    unless current_user.user_permission.extras || current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end
end

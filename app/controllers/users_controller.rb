class UsersController < ApplicationController
  before_action :verify_admin, only: [:new, :edit, :index]

  def home; end

  def destroy_session
    reset_session
    redirect_to root_path
  end

  def profile
    @user = current_user
  end

  def update
    flash[:alert] = []
    @user = current_user
    
    if params[:password].present?
      @user.assign_attributes(name: params[:name], password: params[:password])
    else
      @user.assign_attributes(name: params[:name])
    end

    @user.valid?
    @user.errors.full_messages.each do |message|
      flash[:alert] << message
    end

    @confirm_password = nil

    if password_and_confirm_password_match?
      if @user.save
        redirect_to my_profile_path
        flash[:notice] = "Perfil atualizado com sucesso!"
      else
        render :profile
      end
    else
      flash[:alert] << "As senhas não coincidem."
      @confirm_password = true
      render :profile
    end
  end

  def new
    @user = User.new
  end
  
  def create
    flash[:alert] = []
    @user = User.new(name: params[:name], password: params[:password])

    @user.valid?
    @user.errors.full_messages.each do |message|
      flash[:alert] << message
    end

    @confirm_password = nil

    if password_and_confirm_password_match?
      if @user.save
        UserPermission.create(user: @user)
        redirect_to cadastro_usuario_path
        flash[:notice] = "Usuário criado com sucesso!"
      else
        render :new
      end
    else
      flash[:alert] << "As senhas não coincidem."
      @confirm_password = true
      render :new
    end
  end

  def index
    @users = User.all
    @users = @users.reject { |user| user.user_permission.admin == true }
  end

  def edit
    @user = User.find(params[:id])
  end

  def admin_update
    @user = User.find(params[:id])

    if params[:commit] == "Resetar Senha"
      @user.update(password: "123456")
      flash[:notice] = "Senha resetada com sucesso! (123456)"
      redirect_to index_users_path
      return
    end

    @user.user_permission.update(
                                  entities: params[:entities],
                                  entities_create: params[:entities_create],
                                  financial: params[:financial],
                                  financial_create: params[:financial_create],
                                )
    if @user.update(name: params[:name])
      flash[:notice] = "Usuário atualizado com sucesso!"
      redirect_to index_users_path
    else
      flash[:alert] = "Erro ao atualizar Nome do Usuário!"
      render :edit
    end
  end

  private
  
  def password_and_confirm_password_match?
    params[:password] == params[:confirm_password]
  end

  private

  def verify_admin   
    unless current_user.user_permission.admin
      redirect_to root_path, info: "Você não tem permissão para acessar essa página"
      return
    end
  end
end

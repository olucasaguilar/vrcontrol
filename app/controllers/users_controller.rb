class UsersController < ApplicationController
  def index
  end

  def destroy_session
    reset_session
    redirect_to root_path
  end

  def profile
    @user = current_user
  end

  def update
    @user = current_user
  
    if password_and_confirm_password_match?
      if params[:password].present?
        if @user.update(name: params[:name], password: params[:password])
          redirect_to my_profile_path
          flash[:notice] = "Perfil atualizado com sucesso!"
        else
          flash[:alert] = []
          @user.errors.full_messages.each do |message|
            flash[:alert] << message
          end
          render :profile
        end
      else
        if @user.update(name: params[:name])
          redirect_to my_profile_path
          flash[:notice] = "Perfil atualizado com sucesso!"
        else
          flash[:alert] = "Erro ao atualizar perfil!"
          render :profile
        end
      end
    else
      flash[:alert] = "As senhas não coincidem."
      render :profile
    end
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(name: params[:name], password: params[:password])
    
    if password_and_confirm_password_match?
      if @user.save
        UserPermission.create(user: @user)
        redirect_to cadastro_usuario_path
        flash[:notice] = "Usuário criado com sucesso!"
      else
        flash[:alert] = []
        @user.errors.full_messages.each do |message|
          flash[:alert] << message
        end
        render :new
      end
    else
      flash[:alert] = "As senhas não coincidem."
      render :new
    end
  end

  def all
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
      redirect_to all_users_path
      return
    end

    @user.user_permission.update(
                                  entities: params[:entities],
                                  entities_create: params[:entities_create]
                                )
    if @user.update(name: params[:name])
      flash[:notice] = "Usuário atualizado com sucesso!"
      redirect_to all_users_path
    else
      flash[:alert] = "Erro ao atualizar Nome do Usuário!"
      render :edit
    end
  end

  private
  
  def password_and_confirm_password_match?
    params[:password] == params[:confirm_password]
  end  
end

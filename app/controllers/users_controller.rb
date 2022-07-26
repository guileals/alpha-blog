class UsersController < ApplicationController
    
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, only: [:edit, :update]
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def new
        @user = User.new
    end

    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 3)
    end

    def index 
        @users = User.paginate(page: params[:page], per_page: 3)
    end

    def edit
    end
    
    def update
        if @user.update(user_params)
            flash[:notice] = "Usuário atualizado com sucesso!"
            redirect_to @user
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Usuário criado com sucesso! Bem vindo, #{@user.username}!"
            redirect_to articles_path
        else
            render 'new', status: :unprocessable_entity
        end
    end

    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user
        flash[:notice] = "Usuário apagado com sucesso!"
        redirect_to articles_path, status: :see_other
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            # flash[:alert] = "Você só pode editar ou deletar seus próprios artigos"
            redirect_to @user, alert: "Você só pode editar ou deletar sua própria conta!"
        end
    end

end

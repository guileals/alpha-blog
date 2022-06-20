class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            flash[:notice] = "Usuário atualizado com sucesso!"
            redirect_to articles_path
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:notice] = "Usuário criado com sucesso! Bem vindo, #{@user.username}!}"
            redirect_to articles_path
        else
            render 'new', status: :unprocessable_entity
        end
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

end

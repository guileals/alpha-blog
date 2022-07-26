class ArticlesController < ApplicationController
    
    before_action :set_article, only: [:edit, :update, :show, :destroy]
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def show
    end

    def index
        @articles = Article.paginate(page: params[:page], per_page: 3)
    end

    def new
        @article = Article.new
    end

    def edit
    end

    def destroy
        @article.destroy
        redirect_to articles_path, status: :see_other # Rails 7 fix!!!
    end
    
    def update
        if @article.update(article_params)
            flash[:notice] = "Artigo atualizado com sucesso!"
            redirect_to @article
        else
            render 'edit', status: :unprocessable_entity
        end
    end
     
    def create 
        # render plain: params[:article]
        @article = Article.new(article_params)
        @article.user = current_user
        if @article.save
            flash[:notice] = "Artigo criado com sucesso!"
            redirect_to @article
        else
            render 'new', status: :unprocessable_entity
        end
    end 

    private

    def set_article
        @article = Article.find(params[:id])
    end

    def article_params
        params.require(:article).permit(:title, :description)
    end

    def require_same_user
        if current_user != @article.user && !current_user.admin?
            # flash[:alert] = "Você só pode editar ou deletar seus próprios artigos"
            redirect_to @article, alert: "Você só pode editar ou deletar seus próprios artigos!"
        end
    end

end
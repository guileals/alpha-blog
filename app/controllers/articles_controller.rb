class ArticlesController < ApplicationController
    
    before_action :set_article, only: [:edit, :update, :show, :destroy]

    def show
    end

    def index
        @articles = Article.all
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
        @article.user = User.first
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

end
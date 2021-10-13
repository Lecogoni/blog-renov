class PartsController < ApplicationController
    before_action :set_article
    before_action :set_part, only: %i[ show edit update destroy ]

    # GET /parts or /parts.json
    def index
        @parts = Part.all
    end

    # GET /parts/1 or /parts/1.json
    #def show
    #end

    # GET /parts/new
    def new
        @part = @article.parts.build
    end

    # GET /parts/1/edit
    def edit
        @element = @article.parts.build
    end

    # POST /parts or /parts.json
    def create
        @part = @article.parts.build(part_params)

        if @part.save
            #notice = "Un nouveau paragraphe à été ajouté" 
        else
            notice = @part.errors.full_messages.join(" .") << "."
        end
        redirect_to edit_article_path(@article)
        #, notice: "Un nouveau paragraphe à été ajouté" 
    end

    # PATCH/PUT /parts/1 or /parts/1.json
    def update
        if @part.update(part_params)
            redirect_to edit_article_path(@article)
            #, notice: "Le paragraphe à été enregistré" 
        else
            redirect_to edit_article_path(@article) 
        end
    end

    # DELETE /parts/1 or /parts/1.json
    def destroy
        @part.destroy
        redirect_to edit_article_path(@article)
        #, notice: "Part was successfully destroyed."
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
        @article = Article.find(params[:article_id])
    end

    def set_part
        @part = @article.parts.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def part_params
        params.require(:part).permit(:element_type, :content, :image)
    end
end


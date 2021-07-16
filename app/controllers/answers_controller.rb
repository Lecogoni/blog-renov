class AnswersController < ApplicationController

  before_action :find_answerable

    def new
      @answer = Answer.new
    end

    def create
      @answer = @answerable.answers.new(answer_params)

      if @answer.save
        redirect_back fallback_location: root_path
        flash[:success] = "votre réponse a bien été enregistrée" 
      else
        redirect_back fallback_location: root_path
        flash[:error] = "votre réponse n'a pas été enregistrée."
      end
    end

    def destroy
      @answerable = Answer.find_by_id(params[:id])
      @answerable.destroy
      redirect_back fallback_location: root_path
      flash[:success] = "votre réponse a été supprimée." 
    end

    private

    def answer_params
      params.require(:answer).permit(:body, :user_id)
    end

    def find_answerable
      @answerable = Answer.find_by_id(params[:answer_id]) if params[:answer_id]
      @answerable = Post.find_by_id(params[:post_id]) if params[:post_id]
    end

end


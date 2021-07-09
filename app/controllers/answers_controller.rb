class AnswersController < ApplicationController

  before_action :find_answerable

    def new
      @answer = Answer.new
    end

    def create
      @answer = @answerable.answers.new(answer_params)

      if @answer.save
        redirect_back fallback_location: root_path, notice: 'Your answer was successfully posted!'
      else
        redirect_back fallback_location: root_path, notice: "Your answer wasn't posted!"
      end
    end

    private

    def answer_params
      params.require(:answer).permit(:body)
    end

    def find_answerable
      @answerable = Answer.find_by_id(params[:answer_id]) if params[:answer_id]
      @answerable = Post.find_by_id(params[:post_id]) if params[:post_id]
    end

end

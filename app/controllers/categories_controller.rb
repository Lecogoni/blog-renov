class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]


  def new
    @article = Article.new
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

end

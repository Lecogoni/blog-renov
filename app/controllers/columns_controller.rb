class ColumnsController < ApplicationController
  before_action :set_column, only: %i[ show edit update destroy ]


  def new
    column = Column.new
  end

  private

  def set_category
    @column = Column.find(params[:id])
  end

end

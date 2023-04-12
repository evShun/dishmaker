class FoodsController < ApplicationController
  # before_action :set_food , only: [:show, :create]
  def show
    @food = Food.new    
    @foods = Food.where(fridge_id: params[:id])
    # binding.pry
  end
  def create
    @food = Food.new(food_params)
    if @food.save
      redirect_to fridge_food_path(id: params[:fridge_id])
      # redirect_to fridge_food_path(@food.fridge_id) 
    else
      render "show"
    end
  end

  private
  def set_food
    @fridge = Fridge.find(params[:fridge_id])
  end

  def food_params
    params.require(:food).permit(:item).merge(fridge_id: params[:fridge_id])
  end
end
  
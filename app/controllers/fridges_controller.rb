class FridgesController < ApplicationController
  
  def index
  end

  def show
    @fridge = Fridge.new
    @fridges = Fridge.where(user_id: current_user.id)
  end

  def create
    @fridge = Fridge.new(fredge_params)
    if @fridge.save
      redirect_to fridge_path(current_user.id)
    else
      render "show"
    end
  end

private
  def fredge_params
    params.require(:fridge).permit(:name).merge(user_id: current_user.id)
  end
end

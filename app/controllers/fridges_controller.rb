class FridgesController < ApplicationController
  before_action :authenticate_user!, only:[:show,:create]
  before_action :other_login, only:[:show,:create]
  
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

  def other_login
    if user_signed_in? && current_user.id != params[:id].to_i
        redirect_to fridge_path(current_user.id)
    end
  end
end

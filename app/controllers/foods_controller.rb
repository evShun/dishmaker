class FoodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food
  before_action :other_fridge
  require 'openai'
  before_action :set_common_variable, only: [:search]

  def show
    @food = Food.new
  end

  def update
    @food = Food.new(food_params)
    if @food.save
      redirect_to fridge_food_path(fridge_id:current_user.id ,id:params[:id])
    else
      render "show"
    end
  end

  def destroy
    @food = Food.find(params[:fridge_id])
    @food.destroy
    redirect_to fridge_food_path(fridge_id:current_user.id ,id:params[:id])
  end

  def search
    @food = Food.new
    list = Food.where(fridge_id: params[:id]).pluck(:item).join("、")
    content = "次の食材を使用して作成できる料理を教えてください。#{list} "
    response = @client.chat(
               parameters: {
                model: "gpt-3.5-turbo",
                messages: [{ role: "user", content: content}],
                temperature: 0.7,
                           })
    @recipe = response.dig("choices",0,"message","content")
    render "show"
  end

private
  def set_food
    @foods = Food.where(fridge_id: params[:id])
  end

  def food_params
    params.require(:food).permit(:item).merge(fridge_id: params[:id])
  end

  def set_common_variable
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def other_fridge
    @fridge = Fridge.find(params[:id])
    if user_signed_in? && current_user.id != @fridge.user_id
      redirect_to fridge_path(current_user.id)
    end
  end
end
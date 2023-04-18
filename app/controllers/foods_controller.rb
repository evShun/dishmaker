class FoodsController < ApplicationController
  # before_action :set_food , only: [:show, :create]
  require 'openai'
  before_action :set_common_variable, only: [:search]

  def show
    @food = Food.new
    @foods = Food.where(fridge_id: params[:id])
  end

  def update
    @food = Food.new(food_params)
    @foods = Food.where(fridge_id: params[:id])
    if @food.save
      redirect_to fridge_food_path(fridge_id:current_user.id ,id:params[:id])
    else
      render "show"
    end
  end

  def destroy
    food = Food.find(params[:id])
  end
 
  def search
    @food = Food.new
    @foods = Food.where(fridge_id: params[:id])
    
    list = Food.where(fridge_id: params[:id]).pluck(:item).join("、")

    content = "次の食材を使用して作成できる料理を教えてください。#{list} "
    response = @client.chat(
               parameters: {
                model: "gpt-3.5-turbo",
                messages: [{ role: "user", content: content}], # Required.
                temperature: 0.7,
                           })
    binding.pry
    @recipe = response.dig("choices",0,"message","content")
    render "show"
  end

  private
  def set_food
    @fridge = Fridge.find(params[:fridge_id])
  end

  def food_params
    params.require(:food).permit(:item).merge(fridge_id: params[:id])
  end

  # APIキーを設定
  def set_common_variable
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end
end
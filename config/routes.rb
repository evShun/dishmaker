Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "fridges#index"
  resources :fridges do
    resources :foods do
      collection do
        get "search/:id", to: "foods#search", as: "search" 
      end
    end
  end
end

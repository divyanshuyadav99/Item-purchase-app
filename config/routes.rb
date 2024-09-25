Rails.application.routes.draw do
  resources :purchases, only: [:new, :create] do 
    collection do
      get :fetch_all_order_items
    end
  end
  get 'purchase/success', to: 'purchases#success', as: :purchase_success
  root 'purchases#new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

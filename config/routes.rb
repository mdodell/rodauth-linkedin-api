Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/auth/:provider/callback", to: "rodauth#omniauth"
  get '/profile', to: "test#profile"
end


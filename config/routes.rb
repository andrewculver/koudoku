Koudoku::Engine.routes.draw do
  resources :webhooks, only: [:create]
end

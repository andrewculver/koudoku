Koudoku::Engine.routes.draw do
  # e.g. :users
  resources Koudoku.owner_resource, as: :owner do
    resources :subscriptions do
      member do
        post :cancel
      end
    end
  end
  resources :webhooks, only: [:create]
end

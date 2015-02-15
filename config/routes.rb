Koudoku::Engine.routes.draw do
  # e.g. :users
  resources :subscriptions, only: [:new]
  resources Koudoku.owner_resource, as: :owner do
    resources :subscriptions do
      member do
        post :cancel
      end
    end
  end
    
  mount StripeEvent::Engine => '/events'
  
  match '/webhooks', to: redirect('/events'), via: :all
end

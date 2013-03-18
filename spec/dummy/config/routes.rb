Rails.application.routes.draw do
  mount Koudoku::Engine, at: "koudoku"
  match 'pricing' => 'koudoku::subscriptions#index', as: 'pricing'
end

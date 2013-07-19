Rails.application.routes.draw do
  mount Koudoku::Engine, at: "koudoku"
  scope module: 'koudoku' do
    get 'pricing' => 'subscriptions#index', as: 'pricing'
  end
end

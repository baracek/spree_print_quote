Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :orders do
      member do
        get :quote
      end
    end
  end
end
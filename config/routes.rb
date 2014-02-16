Balances::Application.routes.draw do
  devise_for :users

  root to: 'home#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: 'admin/letter_opener'
  end

  resources :addresses do
    get :detect_currency, on: :collection
  end

  namespace :api do
    namespace :rest do
      namespace :v1 do
        resources :addresses, only: [:create]
      end
    end
  end
end

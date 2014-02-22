Balances::Application.routes.draw do
  devise_for :users

  root to: 'home#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: 'admin/letter_opener'
  end

  resources :addresses do
    get :detect_currency, on: :collection
  end

  devise_scope :user do |variable|
    get :settings, to: 'devise/registrations#edit'
  end

  get :terms_privacy, controller: 'home'

  namespace :api do
    namespace :rest do
      namespace :v1 do
        resources :addresses, only: [:create]
      end
    end
  end
end

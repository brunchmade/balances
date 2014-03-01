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

  get :landing, controller: 'home'

  namespace :api do
    namespace :rest do
      namespace :v1 do
        resources :addresses, only: [:create]
        resources :registrations, only: [:create] do
          post :sign_in, on: :collection
          delete :sign_out, on: :collection
        end
        resources :tokens, only: [:create]
      end
    end
  end
end

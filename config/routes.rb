Balances::Application.routes.draw do

  root to: 'static#root'
  get :home, controller: 'static'
  get :teaser, controller: 'static'
  get :terms_privacy, controller: 'static'
  get :import_instructions, controller: 'static'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: 'admin/letter_opener'
  end

  resources :addresses, only: [:index, :show, :create, :update, :destroy] do
    get :detect_currency, on: :collection
    get :info, on: :collection
    post :import, on: :collection
  end

  resources :announcements, only: [:index] do
    put :mark_as_read
  end

  namespace :coinbase do
    get :auth
    get :callback
  end

  get :transactions, controller: :transactions, action: :index

  devise_for :users, controllers: { registrations: 'registrations' }
  devise_scope :user do |variable|
    get :settings, to: 'registrations#edit' # We are using a custom controller
    get :sign_in, to: 'devise/sessions#new'
    get :sign_up, to: 'registrations#new' # We are using a custom controller
    delete :sign_out, to: 'devise/sessions#destroy'
  end

  resources :users, only: [:index, :show]
  namespace :users do
    post :disable_twofactor
    post :enable_twofactor
    get :twofactor_qr
    get :twofactor_verify
    get 'unsubscribe/:email_hash', action: :unsubscribe, as: :unsubscribe
    get 'unsubscribe/:email_hash/confirm', action: :unsubscribe_confirm, as: :unsubscribe_confirm
  end

  get :admin, to: 'admin#index'
  namespace :admin do
    resources :announcements
  end

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

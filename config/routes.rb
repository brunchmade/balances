Balances::Application.routes.draw do
  devise_for :users

  root to: 'static#root'
  get :home, controller: 'static'
  get :teaser, controller: 'static'
  get :terms_privacy, controller: 'static'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: 'admin/letter_opener'
  end

  resources :addresses, only: [:index, :show, :create, :update, :destroy] do
    get :detect_currency, on: :collection
    get :info, on: :collection
  end

  resources :announcements, only: [:index] do
    put :mark_as_read
  end

  namespace :coinbase do
    get :auth
    get :callback
  end

  devise_scope :user do |variable|
    get :settings, to: 'devise/registrations#edit'
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

Balances::Application.routes.draw do
  devise_for :users

  root to: 'home#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: 'admin/letter_opener'
  end

  resources :wallet_addresses
end

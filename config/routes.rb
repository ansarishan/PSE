Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  root to: "home#index"

  get 'dashboard/', to: 'dashboard#index'
  get 'dashboard/index'

  get 'book/:drug_period_id', to: 'book#index', as: 'book'

  get 'invites/', to: 'invites#index'
  get 'invites/new', to: 'invites#new'
  post 'invites/create', to: 'invites#create'

  get 'userlist/', to: 'userlist#index'

  get  'org_onboarding/init(/:url_code)', to: 'org_onboarding#init', as: :org_onboarding_init
  get  'org_onboarding/new_org_admin', to: 'org_onboarding#new_org_admin'
  post 'org_onboarding/create_org_admin', to: 'org_onboarding#create_org_admin'
  get  'org_onboarding/user_agreement', to: 'org_onboarding#user_agreement'
  post 'org_onboarding/signed_user_agreement', to: 'org_onboarding#signed_user_agreement'
  get  'org_onboarding/new_org', to: 'org_onboarding#new_org'
  patch 'org_onboarding/create_org', to: 'org_onboarding#create_org'
  get  'org_onboarding/new_legal', to: 'org_onboarding#new_legal'
  post 'org_onboarding/create_legal', to: 'org_onboarding#create_legal'
  get  'org_onboarding/new_trader', to: 'org_onboarding#new_trader'
  post 'org_onboarding/create_trader', to: 'org_onboarding#create_trader'
  get  'org_onboarding/new_analyst', to: 'org_onboarding#new_analyst'
  post 'org_onboarding/create_analyst', to: 'org_onboarding#create_analyst'

  get 'org_onboarding/completed', to: 'org_onboarding#completed'

  resources :quotes, only: [:destroy, :edit] do
    patch :decline
    patch :accept
  end
  resources :orders, only: [:update, :destroy, :edit] do
    patch :start_contract
    patch :confirm_contract
    patch :cancel_contract
  end
  post 'tradables/create', to: 'tradables#create'
  post 'orders/create', to: 'orders#create'

  get 'contracts_admin', to: 'contracts_admin#index'
  put 'contracts_admin/:drug_period_id/open', to: 'contracts_admin#open', as: 'contracts_admin_open'
  put 'contracts_admin/:drug_period_id/close', to: 'contracts_admin#close', as: 'contracts_admin_close'
  get 'contracts_admin/:drug_period_id/expire', to: 'contracts_admin#expire_form', as: 'contracts_admin_expire_form'
  patch 'contracts_admin/:drug_period_id/expire', to: 'contracts_admin#expire', as: 'contracts_admin_expire'
end

Rails.application.routes.draw do
  root "organizations#index"
  
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :organizations, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      post :join
      get :admin
      patch 'memberships/:id/approve', to: 'organizations#approve_membership', as: :approve_membership
      patch 'memberships/:id/reject', to: 'organizations#reject_membership', as: :reject_membership
      patch 'memberships/:membership_id/update_role', to: 'organizations#update_member_role', as: :update_member_role
      patch 'memberships/:membership_id/remove', to: 'organizations#remove_member', as: :remove_member
    end
    
    resources :projects do
      member do
        patch :complete
      end
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end

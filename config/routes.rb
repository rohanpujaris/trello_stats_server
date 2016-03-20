Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth"

  namespace :api, defaults: { format: "json" }  do
    namespace :v1 do
      resources :members, only: [:index, :update] do
        get 'leaves', on: :collection
      end
      resources :cards, only: [:index]
      resources :card_members, only: [:update]
      resources :sprints, only: [:index, :update]
      resources :lists, only: [:index, :update]
      resources :leaves, except: [:new, :edit]

      get "pull_all_data_from_trello", to: "pull_trello_data#pull_all_data"
      get "authenticate", to: "trello_auth#authenticate"
      get "logout", to: "trello_auth#logout"
    end
  end
end

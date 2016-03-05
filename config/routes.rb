Rails.application.routes.draw do

  namespace :api, defaults: { format: "json" }  do
    namespace :v1 do
      resources :members, only: [:index, :update]
      resources :cards, only: [:index]
      resources :card_members, only: [:update]
      resources :sprints, only: [:index, :update]
      resources :lists, only: [:index, :update]

      get 'pull_all_data_from_trello', to: 'pull_trello_data#pull_all_data'
    end
  end
end

Rails.application.routes.draw do
  resources :snapshots
  resource :extended_api, only: [] do
    get 'projects/:pid/stories', as: 'stories', to: 'extended_api#stories'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

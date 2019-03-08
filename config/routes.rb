Rails.application.routes.draw do
  resources :snapshots do
    collection do
      get 'api_spec'
    end
  end
  resource :extended_api, only: [] do
    get 'projects/:pid/stories', as: 'stories', to: 'extended_api#stories'
    get 'projects/:pid/stories/:sid/transitions', as: 'transitions', to: 'extended_api#story_transitions'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

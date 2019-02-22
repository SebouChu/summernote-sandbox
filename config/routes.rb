Rails.application.routes.draw do
  resources :articles
  post 'uploads' => 'uploads#create'

  get 'test' => 'application#test'

  root to: 'articles#index'
end

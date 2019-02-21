Rails.application.routes.draw do
  resources :articles
  post 'uploads' => 'uploads#create'
  
  root to: 'articles#index'
end

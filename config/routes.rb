Rails.application.routes.draw do
  get '/login', to: 'session#new'
  get '/logout', to: 'session#delete'
  post '/login', to: 'session#create'

  root 'session#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

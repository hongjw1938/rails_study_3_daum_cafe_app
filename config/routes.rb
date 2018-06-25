Rails.application.routes.draw do
  

  resources :themes
  root 'board#index'
  get '/boards' => 'board#index'
  
  
  get '/board/test' => 'board#test'
  get '/board/new' => 'board#new'
  get '/board/:id' => 'board#show'
  
  post '/boards' => 'board#create'
  get '/board/:id/edit' => 'board#edit'
  
  put '/board/:id' => 'board#update'
  patch '/board/:id' => 'board#update'
  delete '/board/:id' => 'board#destroy'
  
  
  
  get '/users' => 'user#index'
  get '/sign_up' => 'user#new'
  get '/sign_in' => 'user#sign_in'
  post '/sign_in' => 'user#login'
  get '/logout' => 'user#logout'
  post '/users' => 'user#create'
  get '/user/:id' => 'user#show'
  get '/user/:id/edit' => 'user#edit'
  patch '/user/:id' => 'user#update'
  put '/user/:id' => 'user#update'
  
  
  
  get '/cafe/index' => 'cafe#index'
  get '/cafe/new' => 'cafe#new'
  
  post '/cafes' => 'cafe#create'
  get '/cafe/:id' => 'cafe#show'
  
  get '/cafe/:id/edit' => 'cafe#edit'
  put '/cafe/:id' => 'cafe#update'
  patch '/cafe/:id' => 'cafe#update'
  
  delete '/cafe/:id' => 'cafe#destroy'
end

Rails.application.routes.draw do

  root 'organizations#show'
  resources :people
  resources :teams

end

Rails.application.routes.draw do

  root 'organizations#show'
  resources :people
  resources :teams
  resources :memberships, :only => [:new, :create, :destroy]

end

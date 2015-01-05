Rails.application.routes.draw do

  root 'organizations#show'
  get 'organizations/generate_pairings' => 'organizations#generate_pairings'
  
  resources :people
  resources :teams
  resources :memberships, :only => [:new, :create, :destroy]

end

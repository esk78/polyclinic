Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :patients
      resources :appointment_statuses
      resources :doctor_categories
      resources :appointments
      resources :doctors

      root to: "users#index"
    end
  get 'home/index'
  resources :patients
  resources :doctors
  resources :appointments
  get '/appointments/new/:doctor_id' => 'appointments#new'
  # get '/appointments/:id/edit' => 'appointments#edit'
  # post '/appointments' => 'appointments#create'
  # patch '/appointments/:id' => 'appointments#update'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  get 'doctors_search/:doctor_category_id' => 'patients#doctors_search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "home#index"
end

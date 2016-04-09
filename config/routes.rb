Rails.application.routes.draw do
  devise_for :users
  
  root :to => 'contacts#index'

  resources :contacts
  resources :meeting

  resources :pusher do
    collection do 
      post 'auth'
    end
  end

  namespace :api do      
    namespace :v1 do
      post   'meeting-start' => 'meeting#start_session'
      get   'meeting-end/:channel' => 'meeting#end_session'
      get   'meeting-join/:channel' => 'meeting#join_session'
    end
  end

  get '/meeting-channel/:channel' => 'meeting#channel'

end

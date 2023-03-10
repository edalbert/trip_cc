Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope :users do
    get '/:user_id/feed', to: 'sleep_sessions#feed'
    post '/:user_id/clock_in', to: 'sleep_sessions#create'

    post '/:followed_id/follow', to: 'followings#create'
    delete '/:followed_id/unfollow', to: 'followings#delete'
  end
end

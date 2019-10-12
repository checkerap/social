Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    post "users"                        => 'users#create'
    post "users/:user_id/follow/:id"    => "users#follow"
    post "users/:user_id/unfollow/:id"  => "users#unfollow"
    get "users/:user_id/followers"      => "users#followers"
  end
end

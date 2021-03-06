Gamerankr::Application.routes.draw do
  get "/search" => 'search#search'
  get "/my_games" => "rankings#mine"
  get "/my_shelf/:id" => "rankings#my_shelf", :as => :my_shelf
  
  resources :designers, :developers, :friends,
    :game_genres, :game_series, :genres, :manufacturers,
    :profile_questions, :publishers,
    :rankings, :ranking_shelves, :series, :shelves
  
  get "/comments/notify" => "comments#notify"
  
  resources :platforms do
    member do
      get 'merge'
      post 'merge'
    end
    collection do
      get 'generations'
    end
  end
  
  resources :games do
    member do
      get 'screenshots', :to => 'screenshots#game'
      get 'game_genres', :to => 'game_genres#game'
    end
  end
  resources :ports do
    member do
      get 'cover'
    end
  end
  resources :users do
    member do
      get 'rankings', :to => 'rankings#user'
    end
  end
  
  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/session/fake_sign_in/:id', :to => 'sessions#fake_sign_in'
  get '/about', :to => 'main#about'
  get '/fb_test', :to => 'main#fb_test'
  get '/dialog/feed', :to => 'dialog#feed'
  
  get "/search_and_edit" => "admin#search_and_edit"
  post "/multi_edit" => "admin#multi_edit"
  
  root :to => "main#index"
end

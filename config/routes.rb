RailsMongoid::Application.routes.draw do

  # Add comment from post show page
  # match "posts/:post_id/comments", :action=>"create_comment_from_post", :via=>[:post], :controller=>"comments"

  resources :users do
    resources :preference
    resources :posts do
      put :like
      resources :location  
      resources :comments
      resources :photos
    end
    get 'countries', to: 'static_pages#countries'
    get 'archive', to: 'static_pages#archive'
    get 'overview', to: 'static_pages#overview'
    get 'results', to: 'static_pages#results'
  end

  resources :friendships, only: [:create, :destroy]

  resources :sessions, only: [:new, :create, :destroy]

  root 'posts#index'

  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/gfs/:model/:field/:user_id/:filename', to: 'gridfs#serve', via: 'get'
  match "/uploads/:model/:field/:photo_id/:filename", to: 'photos#serve', via: 'get'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

WeiboGift::Application.routes.draw do
  


  resources :bcards

  match 'root' => 'home#index', :as => :root
  match '/' => 'home#index', :as => :/
  match 'user'  => 'users#index', :as => :user  
#  match 'connect' => 'user#connect', :as => :connect
  match "callback" => 'sessions#callback', :as => :callback

  match 'login' => 'users#new', :as => :login
  match "signout"  => 'sessions#signout', :as => :signout
  
# cards 
  match 'createcard' => 'users#create_card', :as => :createcard
  match 'create_card_input' => 'users#create_card_input', :as => :create_card_input
  match 'send_card' => 'users#send_card', :as => :sendcard
  match 'show_post' => 'users#show_post', :as => :show_post
  match 'show_bcard' => 'users#show_bcard', :as => :show_bcard
  
# friends
  match 'get_friends' => 'users#get_friends', :as => :get_friends  
# picture 
  match 'card_compose' => 'pictures#card_compose', :as => :card_compose
  
  #pictures
  match 'cropping' =>'pictures#cropping', :as => :cropping
  resources :users
  resources :pictures
  resources :templates
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

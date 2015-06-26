Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'admin_credit_cards/to_use_credit_cards'
      post 'admin_credit_cards/use_credit_card'
      get 'admin_credit_cards/cancel_use'
    end
  end

  resources :agencies    , only: [:show, :index] # JSON Agencies for SELECT2

  resources :to_use_credit_cards do
    collection do
      get :taked_credit_cards
      get :used_credit_cards
      get :all_credit_cards
      get :disabled_credit_cards
      post :use_credit_card
      get :credit_card_reports
      get :credit_card_report_expiration
    end
  end

  root 'to_use_credit_cards#index'
  get ':controller/:action(/:id)'

  get '/logout' => 'application#logout'
  
  # Permite ver los estados de las distintas colas(resque)
  mount Resque::Server, :at => "/resque"  

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

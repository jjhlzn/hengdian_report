Rails.application.routes.draw do
  root 'network_order_today_reports#index'
  get 'network_order_report/latest_30days_report'
  get 'network_order_yearly_reports/mobile_company_cmp'
  get 'network_order_today_reports/reserve'
  get 'network_order_today_reports/official'
  get 'network_order_today_reports/official_website'
  get 'network_order_today_reports/official_taobao'
  get 'group_order_day_reports/reserve'
  get 'group_order_day_reports/latest_30days_report'
  get 'all_yearly_reports/get_selltype_compare'
  get 'timer_task/init'

  resources :network_order_area_compares
  resources :network_order_today_reports
  resources :network_order_today_ticket_reports
  resources :network_order_yearly_agent_reports
  resources :network_order_yearly_reports
  resources :network_order_month_reports
  resources :group_order_day_reports
  resources :group_order_month_reports
  resources :all_yearly_reports
  resources :timer_task

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

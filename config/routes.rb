Rails.application.routes.draw do
    # Semi-static page routes
    get 'home', to: 'home#index', as: :home
    get 'home/about', to: 'home#about', as: :about
    get 'home/contact', to: 'home#contact', as: :contact
    get 'home/privacy', to: 'home#privacy', as: :privacy

    # Authentication routes
    resources :sessions
    get 'login', to: 'sessions#new', as: :login
    get 'logout', to: 'sessions#destroy', as: :logout
  
    # Resource routes (maps HTTP verbs to controller actions automatically):
    resources :officers
    resources :investigations
    resources :units
    resources :crimes
    resources :investigation_notes
  
    # Routes for assignments
    get 'assignments/new', to: 'assignments#new', as: :new_assignment
    post 'assignments', to: 'assignments#create', as: :assignments
    patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment
  
    # Routes for crime_investigations
    get 'crime_investigations/new', to: 'crime_investigations#new', as: :new_crime_investigation
    post 'crime_investigations', to: 'crime_investigations#create', as: :crime_investigations
    delete 'crime_investigations/:id', to: 'crime_investigations#destroy', as: :destroy_crime_investigation
  

    # Toggle paths
  
  
    # Other custom routes
    patch 'investigations/:id/close', to: 'investigations#close', as: :close_investigation
  
    # Routes for searching
  
  
    # You can have the root of your site routed with 'root'
    root 'home#index'
end

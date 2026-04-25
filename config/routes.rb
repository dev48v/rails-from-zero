# STEP 3 — URL → controller wiring.
# `resources :books` is shorthand for the seven standard CRUD routes:
#   GET    /books          -> books#index
#   GET    /books/new      -> books#new
#   POST   /books          -> books#create
#   GET    /books/:id      -> books#show
#   GET    /books/:id/edit -> books#edit
#   PATCH  /books/:id      -> books#update
#   DELETE /books/:id      -> books#destroy
# Run `bin/rails routes` to see the full list with their helper names.
Rails.application.routes.draw do
  # Health check Rails generates by default — handy when the app is deployed
  # behind a load balancer. Returns 200 OK if Rails boots successfully.
  get "up" => "rails/health#show", as: :rails_health_check

  # The library itself.
  resources :books

  # Step 6 will add Open Library search; Step 7 will add a one-click import
  # from a search result. Defining them now keeps Step 3's diff cohesive.
  get  "search" => "books#search",  as: :search
  post "books/import" => "books#import", as: :import_book

  # Land on the library when someone hits the bare domain.
  root "books#index"
end

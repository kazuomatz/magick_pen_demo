Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root  'top#index'

  get 'bulma', to: "top#index_bulma"
  get 'bootstrap', to: "top#index_bootstrap"

end

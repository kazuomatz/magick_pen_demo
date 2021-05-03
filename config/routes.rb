Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root  'top#index'
  get 'index2', to: "top#index2"

end

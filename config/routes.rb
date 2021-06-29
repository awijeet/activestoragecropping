Rails.application.routes.draw do
  get 'ajax/cropper'
  resources :profiles
  get '/fetch_image' => "ajax#fetch_image"
  get '/fetch_cropping_status' => 'ajax#fetch_cropping_status'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

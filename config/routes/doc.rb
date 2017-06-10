namespace :doc do

  root 'doc#index'

  # fields
  get 'fields_text', to: 'fields#text', as: 'fields_text'
  get 'fields_media', to: 'fields#media', as: 'fields_media'
  get 'fields_geolocalization', to: 'fields#geolocalization', as: 'fields_geolocalization'


end
Rails.application.routes.draw do
  get 'art_galleries/index'
  post 'art_galleries/log_visitor_records'

  root 'art_galleries#index'
end

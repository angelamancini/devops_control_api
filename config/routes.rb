require 'api_constraints'

Rails.application.routes.draw do
  # API definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      get 's3/:bucket/:file_name/file_exists/', to: 's3#file_exists', as: 's3_file_exists'
      post 's3/:bucket/file_copy/', to: 's3#file_copy', as: 's3_file_copy'
      get 'ec2/lookup_instance', to: 'ec2#lookup_instance', as: 'ec2_lookup_instance'
      # resources :github
      # resources :right_scale
      # resources :cloud_flare
    end
  end
end

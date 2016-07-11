Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
                  constraints: ApiConstraints.new(version: 1, default: true) do
      get 's3/:bucket/file_exists/', to: 's3#show', as: 's3_file_exists'
      post 's3/:bucket/file_copy/', to: 's3#create', as: 's3_file_copy'
      get 'ec2/lookup_instance', to: 'ec2#index', as: 'ec2_lookup_instance'
    end
  end
end

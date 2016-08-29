Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
                  constraints: ApiConstraints.new(version: 1, default: true) do
      get 'health_check', to: 'health_check#index', as: 'health_check'
      get 's3/:bucket/file_exists', to: 's3#show', as: 's3_file_exists'
      post 's3/:bucket/file_copy', to: 's3#create', as: 's3_file_copy'
      get 'ec2/lookup_instance', to: 'ec2_lookup#index', as: 'ec2_lookup_instance'
      post 'cloudflare/page_rule/new', to: 'page_rules#create', as: 'page_rule_create'
      post 'cloudflare/page_rule/delete', to: 'page_rules#delete', as: 'page_rule_delete'
    end
  end
  get 'health_check', to: 'health_check#index', as: 'health_check'
end

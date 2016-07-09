Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do
        get 's3/:bucket/file_exists/', to: 's3#show', as: 's3_file_exists'
        post 's3/:bucket/file_copy/', to: 's3#create', as: 's3_file_copy'
        get 'ec2/lookup_instance', to: 'ec2#lookup_instance', as: 'ec2_lookup_instance'
      end
    end
  end
end

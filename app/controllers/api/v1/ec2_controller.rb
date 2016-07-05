# app/controllers/api/v1/ec2_controller.rb

module Api::V1
  class Ec2Controller < ApiController

    # GET /v1/ec2/lookup_instance
    def lookup_instance
      # curl -X POST -F 'region=us-east-1' -F 'filter=' localhost:9292/ec2/lookup
      # http_status, data = Ec2Lookup.new(params).instance_lookup
      # status http_status
      # data
    end
  end
end

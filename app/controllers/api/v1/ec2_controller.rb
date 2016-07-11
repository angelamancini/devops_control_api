# app/controllers/api/v1/ec2_controller.rb

module Api::V1
  class Ec2Controller < ApiController

    # GET /v1/ec2/lookup_instance
    def index
      # curl -X POST -F 'region=us-east-1' -F 'filter=' localhost:9292/ec2/lookup
      @http_status, @data = Ec2::LookupInstance.new.lookup( request.headers['region'],
                                                            request.headers['filter']
                                                          )
      render json: @data, status: @http_status
    end
  end
end

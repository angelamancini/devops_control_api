# app/controllers/api/v1/ec2_controller.rb

module Api::V1
  class Ec2LookupController < ApiController

    # GET /ec2/lookup_instance
    def index
      @http_status, @data = Ec2::LookupInstance.new.lookup( request.headers['region'],
                                                            request.headers['filter']
                                                          )
      render json: @data, status: @http_status
    end
  end
end

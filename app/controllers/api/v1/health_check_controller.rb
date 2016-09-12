module Api::V1
  class HealthCheckController < ApiController

    # GET /health_check
    def index
      @http_status = 200
      @data = 'devops control api: OK'
      render json: @data, status: @http_status
    end
  end
end

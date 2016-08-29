class HealthCheckController < ApplicationController

  # GET /health_check
  def index
    @http_status = 200
    @data = 'base url: OK' 
   render json: @data, status: @http_status
  end
end

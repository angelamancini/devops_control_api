module Api::V1
  class PageRulesController < ApiController

    # post /cloudflare/page_rule/new
    def index
      # @http_status, @data = Ec2::LookupInstance.new.lookup( request.headers['region'],
      #                                                       request.headers['filter']
      #                                                     )
      # render json: @data, status: @http_status
    end

    def create
    end

    def delete
    end
  end
end

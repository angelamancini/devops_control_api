module Api::V1
  class PageRulesController < ApiController

    # post /cloudflare/page_rule/new
    def create
      @http_status, @data = Cloudflare::PageRule.new.create_redirect( params[:zone],
                                                                      params[:app_url],
                                                                      params[:forward_url]
                                                                    )
      render json: @data, status: @http_status
    end

    def delete
      @http_status, @data = Cloudflare::PageRule.new.delete_rule( params[:zone],
                                                                  params[:app_url]
                                                                )
      render json: @data, status: @http_status
    end
  end
end

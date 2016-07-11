# app/controllers/api/v1/s3_controller.rb

module Api::V1
  class S3Controller < ApiController

    # GET /s3/:bucket/file_exists
    def show
      # binding.pry
      @http_status, @data = S3::CopyFile.new.file_exists( request.headers['region'],
                                                        params[:bucket],
                                                        request.headers['file']
                                                      )
      render json: @data, status: @http_status
    end

    # POST /s3/:bucket/file_copy
    def create
      @http_status, @data = S3::CopyFile.new.copy_file( request.headers['region'],
                                                      params[:bucket],
                                                      request.headers['file'],
                                                      request.headers['destination']
                                                      )
      render json: @data, status: @http_status
    end
  end
end

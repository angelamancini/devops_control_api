# app/controllers/api/v1/s3_controller.rb

module Api::V1
  class S3Controller < ApiController

    # GET /v1/s3/:bucket/:file_name/file_exists
    def file_exists
      http_status, data = S3Copy.new(params).copy_file
      status http_status
      data
    end

    # POST /v1/s3/:bucket/file_copy
    def file_copy
      http_status, data = S3Copy.new(params).file_exists
      status http_status
      data
    end

  end
end

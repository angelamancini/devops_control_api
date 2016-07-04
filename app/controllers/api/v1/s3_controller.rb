# app/controllers/api/v1/s3_controller.rb

module Api::V1
  class S3Controller < ApiController

    # GET /v1/s3/:bucket/:file_name/file_exists
    def file_exists
      region = params[:region]
      bucket = params[:source_bucket]
      file = params[:file_name]
      http_status, data = S3::CopyFile.new.copy_file(region, bucket, file)
      status http_status
      data
    end

    # POST /v1/s3/:bucket/file_copy
    def file_copy
      region = params[:region]
      bucket = params[:source_bucket]
      file = params[:file_name]
      destination = params[:destination]
      http_status, data = S3::CopyFile.new.file_exists(region, source_bucket, file, destination)
      status http_status
      data
    end

  end
end

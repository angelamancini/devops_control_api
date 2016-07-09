# app/controllers/api/v1/s3_controller.rb

module Api::V1
  class S3Controller < ApiController

    # GET /v1/s3/:bucket/file_exists
    def show
      binding.pry
      # http_status, data =
      S3::CopyFile.new.file_exists( params[:region],
                                    params[:bucket],
                                    params[:file]
                                  )

      # status http_status
      # data
    end

    # POST /v1/s3/:bucket/file_copy
    def create
      http_status, data = S3::CopyFile.new.copy_file( params[:region],
                                                      params[:bucket],
                                                      params[:file],
                                                      params[:destination]
                                                      )
      status http_status
      data
    end

    def index
      @files = [
        { name: 'file.txt' },
        { name: 'image.png'}
      ]
      render json: @files
    end
  end
end

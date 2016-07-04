module S3
require 'aws-sdk'

  class CopyFile

    # Takes the aws api s3 object and sets the bucket
    #
    # @example
    #   get_bucket(bucket_name) # => #<Aws::S3::Bucket name="bucket name">
    #
    # @param region [String] the aws region the bucket is in
    # @param bucket [String] the s3 bucket to perform operations on
    # @return [#<Aws::S3::Bucket name="bucket name">]
    def self.get_bucket(region, bucket)
      s3 = Aws::S3::Resource.new(
        region: region
      )
      s3.bucket(bucket)
    end

    # Does the file exist in the bucket?
    #
    # @example
    #   check_file(bucket, file) # => true
    #
    # @param region [String] the aws region the bucket is in
    # @param bucket [String] the name of the s3 bucket
    # @param file [String] the name of the file
    # @return [true, false]
    def check_file(region, bucket, file)
      bucket = CopyFile.get_bucket(region, bucket)
      response = bucket.object(file).exists?
      if response
        return true
      else
        return false
      end
    end

    # Takes params from initializer and passes them to #check_file method
    #
    # @example
    #   S3Copy.file_exists.new(params) # => Json with http status and message
    #
    # @param region [String] the aws region the bucket is in
    # @param bucket [String] the name of the s3 bucket
    # @param file [String] the name of the file
    # @return [Json] returns appropriate http status and message
    def file_exists(region, bucket, file)
      if check_file(region, bucket, file)
        [200,{ message: "#{file} exists." }.to_json]
      else
        [404,{ message: "#{file} not found." }.to_json]
      end
    end

    # Copies a specific file from one s3 bucket to another
    #
    # @example
    #   S3Copy.copy_file.new(params) # => Json with http status and message
    #
    # @param region [String] the aws region the bucket is in
    # @param source_bucket [String] the originating s3 bucket
    # @param file [String] the file name with path relative to the source
    # bucket
    # @param destination [String] the file name with full path of the destination
    # s3 bucket
    # @return [Json] returns appropriate http status and message
    def copy_file(region, source_bucket, file, destination)
      bucket = get_bucket(region, source_bucket)
      object = bucket.object(file)
      destination_bucket = destination.split('/').first
      destination_file = destination.gsub("#{destination_bucket}/",'')
      dest_file_already_there = check_file(destination_bucket,destination_file)
      if check_file(source_bucket, file)
        if dest_file_already_there
          [200,{ message: "#{file} exists." }.to_json]
        else
          object.copy_to(destination)
          # if object copies, return a 201
          [201,{ message: "#{file} copied." }.to_json]
          # if object does not copy, return appropriate error
        end
      else
        [404,{ message: "#{file} not found." }.to_json]
      end
    end
  end
end

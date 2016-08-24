module Ec2
  require 'aws-sdk'

  # Returns the ec2 object bucket
  #
  # @example
  #   client(region) # => #<Aws::S3::Bucket name="bucket name">
  #
  # @param region [String] the aws region the bucket is in
  # @param bucket [String] the s3 bucket to perform operations on
  # @return [#<Aws::S3::Bucket name="bucket name">]
  def self.client(region)
    ec2 = Aws::EC2::Resource.new(
      region: region
    )

  end
end

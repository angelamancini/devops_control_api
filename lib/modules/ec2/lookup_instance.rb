module Ec2
  require 'aws-sdk'

  class LookupInstance

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

    def parse_filter(filter)
      instance_uid_regex = /i-\w*/
      ipv4_ip_regex = /\b(?!(10|172\.(1[6-9]|2[0-9]|3[0-2])|192\.168))(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b/
      private_ip_regex = /^(10\.\d+|172\.(1[6-9]|2\d|3[0-1])|192\.168)(\.\d+){2}$/
      case filter
        # tags format [{tag-key:tag-value}]
        when filter.kind_of?(Array)
          instances = find_by_tags(filter)
        when instance_uid_regex
          instances = find_by_uid(filter)
        when private_ip_regex
          instances = find_by_private_ip(filter)
        when ipv4_ip_regex
          instances = find_by_ip(filter)
      else
        instances = find_by_name(filter)
      end
      return instances
    end

    def find_by_uid(uid)
      @ec2.instances({
        dry_run: false,
        instance_ids: [uid]
      })
    end

    def find_by_private_ip(ip)
      @ec2.instances({
        dry_run: false,
        filters: [
          {
            name: "private-ip-address",
            values: [ip]
          }
        ]
      })
    end

    def find_by_ip(ip)
      @ec2.instances({
        dry_run: false,
        filters: [
          {
            name: "ip-address",
            values: [ip]
          }
        ]
      })
    end

    def find_by_name(name)
      @ec2.instances({
        dry_run: false,
        filters: [
          {
            name: 'tag:Name',
            values: [name]
          }
        ]
      })
    end

    def find_by_tags(tags)
      filters = []
      tags.each do |tag|
        filters.push(tag.map{|k,v| { name: "tag:#{k}", values: [v] }}.first)
      end
      @ec2.instances({
        dry_run: false,
        filters: filters
      })
    end

    def lookup(region, filter)
      begin
        @ec2 = LookupInstance.client(region)
        instances = parse_filter(filter)
        instance_data = []
        instances.each do |instance|
          data = {
            id: instance.id,
            state: instance.state.name,
            public_ip_address: instance.public_ip_address,
            private_ip_address: instance.private_ip_address,
            launch_time: instance.launch_time,
            availability_zone: instance.placement.availability_zone,
            vpc: instance.vpc_id
          }
          instance.tags.each do |tag|
            data[tag.key.downcase.to_sym] = tag.value
          end
          instance_data.push(data)
        end
        if instance_data.count == 0
          [404,{ message: 'No matching results'}.to_json]
        else
          [200, instance_data.to_json]
        end
      rescue Aws::EC2::Errors::AuthFailure
        [401,{ message: 'AWS was not able to validate the provided access credentials'}.to_json]
      end
    end

  end
end

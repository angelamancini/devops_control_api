module Ec2
  require 'aws-sdk'

  class LookupInstance

    # Takes the filter term and calls the correct lookup method
    # @param filter [String, Array] the filter method to find instances. Array
    # to look up tags, String for other methods
    # @return [Array]
    def parse_filter(filter)
      instance_uid_regex = /i-\w*/
      ipv4_ip_regex = /\b(?!(10|172\.(1[6-9]|2[0-9]|3[0-2])|192\.168))(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b/
      private_ip_regex = /^(10\.\d+|172\.(1[6-9]|2\d|3[0-1])|192\.168)(\.\d+){2}$/
      case filter
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

    # Finds instance by uid
    # @param uid [String] the aws id of the instance
    def find_by_uid(uid)
      @ec2.instances({
        dry_run: false,
        instance_ids: [uid]
      })
    end

    # Finds instance by private ip
    # @param ip [String] the private ip of the instance
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

    # Finds instance by public ip
    # @param ip [String] the public ip of the instance
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

    # Finds instance by name
    # @param name [String] the value of the aws tag "Name"
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

    # Finds instance by tags
    # @param tags [Array] an array of hashes of the key/value pairs
    # [{tag-key:tag-value}]
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

    # Calls the filter method and returns the data in an array of hashes
    # @param region [String] the aws region
    # @param filter [String, Array] the method to filter instances by, either an
    #  array of tags, public ip, private ip, aws uid number or name of the
    # instance.
    # @return [Array]
    def lookup(region, filter)
      begin
        @ec2 = Ec2.client(region)
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

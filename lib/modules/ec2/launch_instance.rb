module Ec2
  require 'aws-sdk'

  class LaunchInstance

    def launch(region, environment, landscape, product, version, instance_type)
      group = "#{landscape}-#{environment}-#{product}"

      instance = ec2.create_instances({
        dry_run: false,
        image_id: "String", # required TODO: get the id of our latest custom AMI
        min_count: 1, # required
        max_count: 1, # required
        key_name: "String", # ssh key
        security_groups: ["String"], # TODO: find the proper security group
        security_group_ids: ["String"], # TODO: find the proper security group_ids
        user_data: "String", # this is a script that can run at boot. TODO: we could use this to start the ansible run.
        instance_type: instance_type, # accepts t1.micro, t2.nano, t2.micro, t2.small, t2.medium, t2.large, m1.small, m1.medium, m1.large, m1.xlarge, m3.medium, m3.large, m3.xlarge, m3.2xlarge, m4.large, m4.xlarge, m4.2xlarge, m4.4xlarge, m4.10xlarge, m2.xlarge, m2.2xlarge, m2.4xlarge, cr1.8xlarge, r3.large, r3.xlarge, r3.2xlarge, r3.4xlarge, r3.8xlarge, x1.4xlarge, x1.8xlarge, x1.16xlarge, x1.32xlarge, i2.xlarge, i2.2xlarge, i2.4xlarge, i2.8xlarge, hi1.4xlarge, hs1.8xlarge, c1.medium, c1.xlarge, c3.large, c3.xlarge, c3.2xlarge, c3.4xlarge, c3.8xlarge, c4.large, c4.xlarge, c4.2xlarge, c4.4xlarge, c4.8xlarge, cc1.4xlarge, cc2.8xlarge, g2.2xlarge, g2.8xlarge, cg1.4xlarge, d2.xlarge, d2.2xlarge, d2.4xlarge, d2.8xlarge TODO: going to have to find the instance_type from somewhere, maybe hubot should keep this info?
        placement: {
          availability_zone: "String", # TODO: smart zone balancing, how many machines are in each zone and launch accordingly.
          group_name: group, # This can probably be used like RS Server Arrays
          tenancy: "default", # accepts default, dedicated, host
          host_id: "String",
          affinity: "String",
        },
        kernel_id: "String",
        ramdisk_id: "String",
        block_device_mappings: [
          {
            virtual_name: "String",
            device_name: "String",
            ebs: {
              snapshot_id: "String",
              volume_size: 1,
              delete_on_termination: false,
              volume_type: "standard", # accepts standard, io1, gp2, sc1, st1
              iops: 1,
              encrypted: false,
            },
            no_device: "String",
          },
        ],
        monitoring: {
          enabled: false, # required
        },
        subnet_id: "String", # TODO: find the subnet id this needs to belong to
        disable_api_termination: false,
        instance_initiated_shutdown_behavior: "stop", # accepts stop, terminate
        private_ip_address: "String",
        client_token: "String",
        additional_info: "String",
        network_interfaces: [
          {
            network_interface_id: "String",
            device_index: 1,
            subnet_id: "String",
            description: "String",
            private_ip_address: "String",
            groups: ["String"],
            delete_on_termination: false,
            private_ip_addresses: [
              {
                private_ip_address: "String", # required
                primary: false,
              },
            ],
            secondary_private_ip_address_count: 1,
            associate_public_ip_address: false,
          },
        ],
        iam_instance_profile: {
          arn: "String", # TODO: find out how to get the IAM instance profile
          name: "String", # TODO: find out how to get the IAM instance profile
        },
        ebs_optimized: false,
      })

      # Wait for the instance to be created, running, and passed status checks
      @ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance[0].id]})
    end

    def tag(instance, environment, landscape, product, version)
      group = "#{landscape}-#{environment}-#{product}"
      name = "#{landscape}-#{environment}-#{product}-#{some_id_number}"
      instance.create_tags({ tags: [
                                      { key: 'Name', value: name },
                                      { key: 'Group', value: group },
                                      { key: 'environment', value: environment },
                                      { key: 'landscape', value: landscape },
                                      { key: 'product', value: product },
                                      { key: 'version', value: version }
                                   ]
                            })
    end

    def new_instance(region, environment, landscape, product, version, instance_type)
      @ec2 = Ec2.client(region)
      instance = launch(region, environment, landscape, product, version, instance_type)
      tag(instance, environment, landscape, product, version)
    end
  end
end

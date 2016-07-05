module Rightscale
  require 'right_api_client'
  class SArray
    class << self
      # connects to the RightScale api and returns the server array
      def connect_to_rightscale(account_id)
        client = RightApi::Client.new(email: RIGHTSCALE_CONFIG['rightscale-email'],
        password: RIGHTSCALE_CONFIG['rightscale-password'],
        account_id: account_id,
        timeout: nil)
        return client
      end
      def get_server_array(array_href, account_id)
        array_id = array_href.gsub('/api/server_arrays/','')
        client = connect_to_rightscale(account_id)
        client.server_arrays(id: array_id).show
      end

      def server_array_list(account_id)
        client = connect_to_rightscale(account_id)
        options = []
        all_arrays = client.server_arrays.index
        all_arrays.each do |server_array|
          options.push({:id => server_array.href, :text => server_array.name })
          # options.push([server_array.name, server_array.href])
        end
        return options.sort { |a,b| a[:text] <=> b[:text] }
      end

      def get_latest_array_tag(account_id, array_href, input_name)
        begin
          server_array = get_server_array(array_href, account_id)
          inputs = []
          # Does this array have any current instances?
          inputs = server_array.next_instance.show.inputs.index
          application_tag = ''
          inputs.each do |input|
            if input.name == input_name
              application_tag = input.value
            end
          end
        rescue RightApi::ApiError
          return 'N/A'
        end
        # remove the 'text:' part of the input value
        return application_tag.gsub('text:', '')
      end

      def update_input(array_id, environment, new_tag, input_name)
        server_array = get_server_array(array_id, environment)
        input_hash = {}
        input_hash[input_name] = "text:#{new_tag}"
        server_array.next_instance.show.inputs.multi_update(inputs: input_hash)
      end

      def launch(array_href, account_id, num_servers)
        # puts "Module::Rightscale::SArray.launch"
        begin
          array_id = array_href.split('/').last
          server_array = get_server_array(array_id, account_id)
          launched_servers = []
          num_servers.times do
            server = server_array.launch
            server_info = {}
            server_info[:name] = server.show.name
            server_info[:state] = server.show.state
            server_info[:href] = server.show.href
            launched_servers.push(server_info)
            sleep(30)
          end
        rescue RightApi::ApiError => e
          account = RIGHTSCALE_CONFIG['accounts'].select { |x| x["id"] == "#{account_id}" }
          account_name = account.first['name']
          raise ArgumentError, "#{server_array.name} (#{account_name} account) - Missing Input Error: #{e.message.split('Response body:').last.gsub("\n",'').gsub('----','').gsub('|-','').strip}"
        end
        return launched_servers

      end

      def old_servers(array_id, account_id, deployment_time)
        server_array = get_server_array(array_id, account_id)
        servers = server_array.current_instances.index
        old_servers = []
        servers.each do |server|
          if server.created_at < deployment_time.strftime('%Y/%m/%d %H:%M:%S %z') && server.state != ('terminated' || 'terminating')
            old_servers.push(server)
          end
        end
        return old_servers
      end
    end
  end
end

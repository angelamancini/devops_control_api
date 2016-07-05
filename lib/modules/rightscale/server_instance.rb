module Rightscale
  require 'right_api_client'
  class ServerInstance
    class << self
      def get_server(server_id, cloud_id, account_id)
        client = RightApi::Client.new(email: RIGHTSCALE_CONFIG['rightscale-email'],
        password: RIGHTSCALE_CONFIG['rightscale-password'],
        account_id: account_id,
        timeout: nil)
        client.clouds(id: cloud_id).show.instances(id: server_id).show
      end

      def get_datacenter(server_href, account_id)
        client = RightApi::Client.new(email: RIGHTSCALE_CONFIG['rightscale-email'],
        password: RIGHTSCALE_CONFIG['rightscale-password'],
        account_id: account_id,
        timeout: nil)
        server_id = server_href.split('/').last
        cloud_id = server_href.split('/')[3]
        server = client.clouds(:id=> cloud_id).show.instances.index(:view=>'full',:id=>server_id).show.datacenter.show.name
      end

      def check_server_status(server_href, account_id)
        server_id = server_href.split('/').last
        cloud_id = server_href.split('/')[3]
        server = get_server(server_id, cloud_id, account_id)
        # Rails.logger.debug "#{server.name}: #{server.state}"
        return server.state
      end

      def terminate_server(server_id, cloud_id, account_id)
        terminated = nil
        server = get_server(server_id, cloud_id, account_id)
        begin
          if server.state != 'terminated'
            # Rails.logger.debug "Terminating #{server.name} in account #{account_id}"
            server.terminate
            terminated = true
          end
        rescue RightApi::ApiError => e
          # raise ArgumentError, "Cannot terminate #{server.name}."
          # Rails.logger.debug "Cannot terminate #{server.name}."
        end
        return terminated
      end
    end
  end
end

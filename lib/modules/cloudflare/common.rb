module Cloudflare
  require 'rubyflare'
  class Common
    # Connects to the CloudFlare APIv4 and returns the client and the zone_id
    #
    # @example
    #   CloudFlare::Common.connect # => #<Rubyflare::Connect:0x00000004790898 @email="cloudflare-email", @api_key="api-key">
    #
    # @param domain [String] the url zone to connect to
    # @return [Object, String] returns the client object and the zone_id
    def self.connect(domain)
      begin
        # binding.pry
        client = Rubyflare.connect_with(CLOUDFLARE_CONFIG['email'], CLOUDFLARE_CONFIG['api_key'])
        # binding.pry
        zones = client.get("zones?name=#{domain}")
        return client, zones.result[:id]
      rescue => e
        puts "An error occured."
        p   e
        puts e.response.errors
        puts e.response.messages
      end
    end
  end
end

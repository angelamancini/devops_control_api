module CloudFlare
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
      client = Rubyflare.connect_with(CLOUDFLARE_CONFIG['email'], CLOUDFLARE_CONFIG['api_key'])
      zones = client.get("zones?name=#{domain}")
      return client, zones.result[:id]
    end
  end
end

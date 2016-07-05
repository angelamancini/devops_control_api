module CloudFlare
  require 'rubyflare'
  class Common
    def self.connect
      client = Rubyflare.connect_with(CLOUDFLARE_CONFIG['email'], CLOUDFLARE_CONFIG['api_key'])
    end

    def self.zone(domain)
      client = CloudFlare::Common.connect
      client.get("zones?name=#{domain}")
      return zones.result[:id]
    end
  end
end

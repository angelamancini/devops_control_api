module CloudFlare
  require 'rubyflare'
  class Common
    def self.connect
      client = Rubyflare.connect_with(CLOUDFLARE_CONFIG['email'], CLOUDFLARE_CONFIG['api_key'])
    end

    def self.zones(domain)
      client = CloudFlare::Common.connect
      client.get("zones?name=#{domain}")
    end
  end
end

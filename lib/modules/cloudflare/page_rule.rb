module Cloudflare
  require 'rubyflare'

  class PageRule
    # Pulls the page rules from the zone and finds the desired rule by url
    #
    # @example
    #   find_rule(domain, app_url) # => "701c50406003184a801df0e53ca0532f"
    #
    # @param domain [String] the domain of the url
    # @param app_url [String] the application url
    # @return [String] returns the rule_id as a string
    def find_rule(domain, app_url)
      client, zone_id = Cloudflare::Common.connect(domain)
      rules = client.get( "zones/#{zone_id}/pagerules")
      rule_id = nil
      rules.results.each do |result|
        if result[:targets].first[:constraint][:value] == "#{app_url}/*" && result[:actions].first[:value][:status_code] == 302
          rule_id = result[:id]
        end
      end
      return rule_id
    end

    def create_redirect(domain, app_url, forwarding_url)
      begin
        client, zone_id = Cloudflare::Common.connect(domain)
        redirect_url_rule ={
                              targets: [
                                {
                                  target: "url",
                                  constraint: {
                                    operator: "matches",
                                    value: "#{app_url}/*"
                                  }
                                }
                              ],
                              actions: [
                                {
                                  id: "forwarding_url",
                                  value: {
                                    url: forwarding_url,
                                    status_code: 302
                                  }
                                }
                              ],
                              status: "active"
                            }
        rule = client.post( "zones/#{zone_id}/pagerules",
                            redirect_url_rule
                          )
        return [201, { message: "Temporary redirect created on #{app_url} to #{forwarding_url}"}.to_json]
      rescue => e
        puts "An error occured."
        [404, { message: "#{e.response.errors} - #{e.response.messages}" }.to_json ]
      end

    end

    def delete_rule(domain, app_url)
      client, zone_id = Cloudflare::Common.connect(domain)
      rule_id = find_rule(domain, app_url)
      # binding.pry
      if rule_id
        rule = client.delete("zones/#{zone_id}/pagerules/#{rule_id}")
        [201, message: "Page Rule deleted for #{app_url}".to_json]
      else
        [404, message: "Page Rule not found for #{app_url}".to_json]
      end
    end
  end
end

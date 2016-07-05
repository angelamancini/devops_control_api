module CloudFlare
  require 'rubyflare'

  class PageRule
    def find_rule(domain, app_url)
      client = CloudFlare::Common.connect
      zones = CloudFlare::Common.zones(domain)
      rules = client.get( "zones/#{zones.result[:id]}/pagerules")
      rule_id = nil
      rules.results.each do |result|
        if result[:targets].first[:constraint][:value] == "#{app_url}/*"
          rule_id = result[:id]
        end
      end
      return rule_id
    end

    def create_rule(domain, app_url, forwarding_url)
      client = CloudFlare::Common.connect
      zone_id = CloudFlare::Common.zone(domain)
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
      rule = client.post( "zones/#{zones_id}/pagerules",
                              redirect_url_rule
                            )
      return rule
    end

    def delete_rule(domain, rule_id)
      client = CloudFlare::Common.connect
      zone_id = CloudFlare::Common.zone(domain)
      rule = client.delete("zones/#{zone_id}/pagerules/#{rule_id}")
      return rule
    end
  end
end

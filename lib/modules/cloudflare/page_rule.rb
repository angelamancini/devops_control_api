module CloudFlare
  require 'rubyflare'

  class PageRule
    def create_rule(domain, app_url, forwarding_url)
      client = CloudFlare::Common.connect
      zones = CloudFlare::Common.zones(domain)
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
                            status: "disabled"
                          }
      rule = client.post( "zones/#{zones.result[:id]}/pagerules",
                              redirect_url_rule
                            )
      return rule
    end

    def activate_rule(domain, rule_id)
      client = CloudFlare::Common.connect
      zones = CloudFlare::Common.zones(domain)
      enable_object = { status: 'active'}
      rule = client.patch("zones/#{zones.result[:id]}/pagerules/#{rule_id}",
                          enable_object
                        )
      return rule
    end

    def delete_rule(domain, rule_id)
      client = CloudFlare::Common.connect
      zones = CloudFlare::Common.zones(domain)
      rule = client.delete("zones/#{zones.result[:id]}/pagerules/#{rule_id}")
      return rule
    end
  end
end

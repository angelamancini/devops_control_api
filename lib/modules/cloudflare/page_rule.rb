module CloudFlare
  require 'rubyflare'

  class PageRule
    # Pulls the page rules from the zone and finds the desired rule by url
    #
    # @example
    #   find_rule(domain, app_url) # => "701c50406003184a801df0e53ca0532f"
    #
    # @param region [String] the aws region the bucket is in
    # @param bucket [String] the s3 bucket to perform operations on
    # @return [String] returns the rule_id as a string
    def find_rule(domain, app_url)
      client, zone_id = CloudFlare::Common.connect(domain)
      rules = client.get( "zones/#{zone_id}/pagerules")
      rule_id = nil
      rules.results.each do |result|
        if result[:targets].first[:constraint][:value] == "#{app_url}/*"
          rule_id = result[:id]
        end
      end
      return rule_id
    end

    def create_rule(domain, app_url, forwarding_url)
      client, zone_id = CloudFlare::Common.connect(domain)
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
      return rule
    end

    def delete_rule(domain, rule_id)
      client, zone_id = CloudFlare::Common.connect(domain)
      rule = client.delete("zones/#{zone_id}/pagerules/#{rule_id}")
      return rule
    end
  end
end

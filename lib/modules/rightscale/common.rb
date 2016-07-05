module Rightscale
  require 'right_api_client'
  class Common
    def self.client(account_id)
      client = RightApi::Client.new(email: RIGHTSCALE_CONFIG['rightscale-email'],
      password: RIGHTSCALE_CONFIG['rightscale-password'],
      account_id: account_id,
      timeout: nil)
      return client
    end
  end
end

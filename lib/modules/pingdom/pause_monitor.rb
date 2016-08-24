module Pingdom

  class PauseMonitor

    def list_checks
      auth = {:username => pingdom_username, :password => pingdom_password }

      response = HTTParty.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => auth, :headers => {"App-Key" => application_key})

      response['checks'].each do |check|
        if check[:hostname].include?(app_url)
          modify_check = HTTParty.put("https://api.pingdom.com/api/2.0/checks/#{check[:id]}", :basic_auth => auth, :headers => {"App-Key" => application_key}), :paused => true
        end
      end
    end
  end
end

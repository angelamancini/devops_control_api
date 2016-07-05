module Rightscale
  require 'right_api_client'
  class AuditEntry
    class << self

      # returns array of audit_entry objects
      def get_audit_entries(account_id, server_id, cloud_id)
        begin
          server = Rightscale::ServerInstance.get_server(server_id, cloud_id, account_id)
          puts "getting audit entries for #{server.name}"
          client = Rightscale::Common.client(account_id)
          entries = client.audit_entries.index(start_date: server.created_at, end_date: Time.now.strftime('%Y/%m/%d %H:%M:%S %z'), limit: 50, filters: { auditee_href: server.href })
          entries_array = []
          entries.each do |entry|
            if entry.show.detail.show.text.include?('Failed to run boot sequence: Failed to run boot bundle')
              audit_details = entry.show.detail.show.text
              last_script = audit_details.scan(/RightScript:.*/).last
              error_details = audit_details.split(last_script).last.split('*RS').first
              error = "#{last_script.delete("****'")}#{error_details}"
              entries_array.push({text: error, log_date: entry.show.updated_at})
            end
          end
          return entries_array
        rescue NoMethodError
          return [{text: 'Could not fetch error(s) from RightScale.', log_date: Time.now}]
        end
      end
    end
  end
end

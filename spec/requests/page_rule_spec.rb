require 'rails_helper'
require 'page_rule'
require 'common'

describe Cloudflare::PageRule do
  let(:domain) { ENV['TEST_DOMAIN'] }
  let(:app_url) { ENV['TEST_APP_URL'] }
  let(:forwarding_url) { ENV['TEST_FORWARD_URL'] }
  let(:client) { Rubyflare.connect_with(CLOUDFLARE_CONFIG['email'], CLOUDFLARE_CONFIG['api_key']) }
  let(:zone_id) { client.get("zones?name=##{domain}") }
  let(:rule_id) { ENV['TEST_RULE_ID'] }

  describe '#create_redirect' do
    it 'creates a temporary redirect and returns a 201' do
      VCR.use_cassette('cloudflare/create_redirect') do
        response = Cloudflare::PageRule.new.create_redirect(domain, app_url, forwarding_url)
        expect(response.first).to eq(201)
      end
    end
  end

  describe "#find_rule" do
    it "given a domain and app_url, it returns the rule_id" do
      VCR.use_cassette('cloudflare/find_rule') do
        rule_id = Cloudflare::PageRule.new.find_rule(domain, app_url)

      end
    end
  end

  describe '#delete_rule' do
    it 'deletes a temporary redirect' do
      VCR.use_cassette('cloudflare/delete_rule') do
        response = Cloudflare::PageRule.new.delete_rule(domain, rule_id)
        expect(response.first).to eq(201)
      end
    end
  end
end

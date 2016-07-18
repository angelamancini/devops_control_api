require 'rails_helper'
require 'page_rule'
require 'common'

describe Cloudflare::PageRule do
  let(:domain) { Rails.application.secrets.test_domain }
  let(:app_url) { Rails.application.secrets.test_app_url }
  let(:forwarding_url) { Rails.application.secrets.test_forward_url }
  let(:client) { Cloudflare::Common.connect(domain) }
  let(:zone_id) { client.get("zones?name=##{domain}") }
  let(:rule_id) { Rails.application.secrets.test_rule_id }

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

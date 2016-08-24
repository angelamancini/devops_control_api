require 'rails_helper'
require 'page_rule'
require 'common'

describe Cloudflare::PageRule do

  describe '#create_redirect' do
    it 'creates a temporary redirect and returns a 201'
  end

  describe "#find_rule" do
    it "given a domain and app_url, it returns the rule_id"
  end

  describe '#delete_rule' do
    it 'deletes a temporary redirect'
  end
end

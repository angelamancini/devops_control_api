require 'rails_helper'

describe Api::V1::Ec2LookupController do

  describe "get #index" do
    it "should respond with status 200"
    it "should return an array of hashes"
    it "should respond with 404 if no instances found"
  end
end

require 'rails_helper'

describe Api::V1::PageRulesController do

  describe "POST #create" do
    it "should respond with 201 if rule created"
    it "should respond with 400 if rule errored"
  end

  describe "POST #delete" do
    it "should respond with 201 if rule deleted"
    it "should respond with 404 if rule was not found"
  end
end

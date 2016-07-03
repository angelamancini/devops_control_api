require 'rails_helper'

describe Api::V1::S3Controller do
  # before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #file_exists" do
    before(:each) do
      # get :file_exists, bucket: ,file_name: , format: :json
    end

    it "should check the bucket for the file"
    it "should respond with 200 if file exists"
    it "should respond with 404 if file not found"
    # it { should respond_with 200 }
  end

  describe "GET #file_copy" do
    before(:each) do
      # get :file_copy, bucket: , format: :json
    end

    it "should copy the file to the destination"
    it "should respond with 200 if file already exists"
    it "should respond with 201 if file copied"
    it "should respond with 404 if file not found in origin bucket"
  end
end

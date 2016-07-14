require 'rails_helper'

describe Api::V1::S3Controller do
  describe "GET #show" do
    it "should check the bucket for the file"
    it "should respond with 200 if file exists"
    it "should respond with 404 if file not found"
  end

  describe "GET #create" do
    it "should copy the file to the destination"
    it "should respond with 200 if file already exists"
    it "should respond with 201 if file copied"
    it "should respond with 404 if file not found in origin bucket"
  end
end

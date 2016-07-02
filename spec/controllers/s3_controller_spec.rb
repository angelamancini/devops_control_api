require 'rails_helper'

describe Api::V1::S3Controller do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #file_exists" do
    before(:each) do
      get :file_exists, bucket: ,file_name: , format: :json
    end

    it ""

    it { should respond_with 200 }
  end
end

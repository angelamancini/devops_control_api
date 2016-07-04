require 'rails_helper'

describe S3Copy do
  describe '#get_bucket' do
    it 'returns the bucket object' do
      expect(S3Copy.new({region: 'us-east-1'}).get_bucket('test-bucket').class).to eq(Aws::S3::Bucket)
    end
  end

  describe '#check_file'

  describe '#file_exists'

  describe '#copy_file'
end

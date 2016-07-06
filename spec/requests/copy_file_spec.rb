
require 'rails_helper'

describe S3::CopyFile do
  let(:region) { 'us-east-1'}
  let(:bucket) { 'hubot-copy-test' }
  let(:file1) { 'Deployinator/preprod/ruby-2.3.1.tar.gz' }
  let(:file2) { 'file.txt' }
  describe '#get_bucket' do
    it 'returns the bucket object' do
      expect(S3::CopyFile.get_bucket(region, bucket).class).to eq(Aws::S3::Bucket)
    end
  end

  describe '#check_file' do
    it 'returns true if file exists' do
      expect(S3::CopyFile.new.check_file(region, bucket, file1)).to eq(true)
    end

    it 'returns false if files does not exist' do
      expect(S3::CopyFile.new.check_file(region, bucket, file2)).to eq(false)
    end
  end

  describe '#file_exists' do
    it 'returns 200 if file exists' do
      expect(S3::CopyFile.new.file_exists(region, bucket, file1).first).to eq(200)
    end

    it 'returns 404 if file not found' do
      expect(S3::CopyFile.new.file_exists(region, bucket, file2).first).to eq(404)
    end
  end

  describe '#copy_file' do
    it 'returns 200 if file exists in destination'
    it 'returns 201 if file is copied'
    it 'returns 404 if file does not exist in source'
  end
end

require 'spec_helper'
# require 'net/sftp'

RSpec.describe Ftpmock::NetSftpProxy do
  describe 'Stubbers' do
    it 'stubs with block' do
      expect_to_be_unstubbed
      Ftpmock::NetSftpProxy.on! do
        expect_to_be_stubbed
      end
      expect_to_be_unstubbed
    end

    it 'stubs and unstubs' do
      expect_to_be_unstubbed
      Ftpmock::NetSftpProxy.on!
      expect_to_be_stubbed

      Ftpmock::NetSftpProxy.off!
      expect_to_be_unstubbed
    end

    def expect_to_be_stubbed
      expect(Net::SFTP).to eq(Ftpmock::NetSftpProxy)
      # expect(Net::SFTP.new).to respond_to(:real)
      # expect(Net::SFTP.new).to respond_to(:configuration)
    end

    def expect_to_be_unstubbed
      expect(Net::SFTP).to eq(Ftpmock::NetSftpProxy::Real)
      # expect(Net::SFTP.new).not_to respond_to(:real)
      # expect(Net::SFTP.new).not_to respond_to(:configuration)
    end
  end
end

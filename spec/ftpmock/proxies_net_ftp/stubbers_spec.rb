RSpec.describe Ftpmock::NetFtpProxy do
  describe 'Stubbers' do
    it 'stubs with block' do
      expect_to_be_unstubbed
      Ftpmock::NetFtpProxy.on! do
        expect_to_be_stubbed
      end
      expect_to_be_unstubbed
    end

    it 'stubs and unstubs' do
      expect_to_be_unstubbed
      Ftpmock::NetFtpProxy.on!
      expect_to_be_stubbed

      Ftpmock::NetFtpProxy.off!
      expect_to_be_unstubbed
    end

    def expect_to_be_stubbed
      expect(Net::FTP).to eq(Ftpmock::NetFtpProxy)
      expect(Net::FTP.new).to respond_to(:real)
      expect(Net::FTP.new).to respond_to(:configuration)
    end

    def expect_to_be_unstubbed
      expect(Net::FTP).to eq(Ftpmock::NetFtpProxy::Real)
      expect(Net::FTP.new).not_to respond_to(:real)
      expect(Net::FTP.new).not_to respond_to(:configuration)
    end
  end
end

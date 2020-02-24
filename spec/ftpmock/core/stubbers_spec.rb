RSpec.describe Ftpmock do
  describe 'stubbers' do
    describe 'on!' do
      it 'delegates to NetFtpProxy' do
        expect(Ftpmock::NetFtpProxy).to receive(:on!)
      end

      after do
        Ftpmock.on! {}
      end
    end

    describe 'off!' do
      it 'delegates to NetFtpProxy' do
        expect(Ftpmock::NetFtpProxy).to receive(:off!)
      end

      after do
        Ftpmock.off!
      end
    end
  end
end

RSpec.describe Ftpmock::NetFtpProxy do
  describe 'Instance Methods' do
    let(:host) { 'ftp.example.com' }
    let(:port) { 21 }
    let(:username) { 'user1' }
    let(:password) { 'changeme123' }

    def expect_real_to_receive_connectivity_args(real)
      expect(real).to receive(:connect).with('ftp.example.com', 21)
      expect(real).to receive(:login).with('user1', 'changeme123')
    end

    describe '#list' do
      describe 'connectivity' do
        it 'fails when called before connect' do
          subject.real = double('Real')
          expect do
            subject.list
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'fails when called before connect and login' do
          subject.real = double('Real')
          subject.connect(host, port)

          expect do
            subject.list
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end
      end

      it 'properly delegates to cache and real' do
        subject.real = double('Real')
        subject.cache = double('Cache')

        subject.connect(host, port)
        subject.login(username, password)

        # cache delegation
        expect(subject.cache).to receive(:list).and_yield

        # real connection
        expect_real_to_receive_connectivity_args(subject.real)

        # real delegation
        expect(subject.real).to receive(:list)

        subject.list
      end
    end
  end
end

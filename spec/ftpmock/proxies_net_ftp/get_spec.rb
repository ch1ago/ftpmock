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

    describe 'get methods' do
      describe 'get' do
        it 'fails when called before connect' do
          subject.real = double('Real')
          expect do
            subject.get('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'fails when called before connect and login' do
          subject.real = double('Real')
          subject.connect(host, port)

          expect do
            subject.get('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'properly delegates to cache and real' do
          subject.real = double('Real')
          subject.cache = double('Cache')

          subject.connect(host, port)
          subject.login(username, password)

          # cache delegation
          expect(subject.cache).to receive(:get).and_yield

          # real connection
          expect_real_to_receive_connectivity_args(subject.real)

          # real delegation
          expect(subject.real).to receive(:get)

          subject.get('robots.txt')
        end
      end

      describe 'gettextfile' do
        it 'fails when called before connect' do
          subject.real = double('Real')
          expect do
            subject.gettextfile('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'fails when called before connect and login' do
          subject.real = double('Real')
          subject.connect(host, port)

          expect do
            subject.gettextfile('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'properly delegates to cache and real' do
          subject.real = double('Real')
          subject.cache = double('Cache')

          subject.connect(host, port)
          subject.login(username, password)

          # cache delegation
          expect(subject.cache).to receive(:get).and_yield

          # real connection
          expect_real_to_receive_connectivity_args(subject.real)

          # real delegation
          expect(subject.real).to receive(:gettextfile)

          subject.gettextfile('robots.txt')
        end
      end

      describe 'getbinaryfile' do
        it 'fails when called before connect' do
          subject.real = double('Real')
          expect do
            subject.getbinaryfile('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'fails when called before connect and login' do
          subject.real = double('Real')
          subject.connect(host, port)

          expect do
            subject.getbinaryfile('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'properly delegates to cache and real' do
          subject.real = double('Real')
          subject.cache = double('Cache')

          subject.connect(host, port)
          subject.login(username, password)

          # cache delegation
          expect(subject.cache).to receive(:get).and_yield

          # real connection
          expect_real_to_receive_connectivity_args(subject.real)

          # real delegation
          expect(subject.real).to receive(:getbinaryfile)

          subject.getbinaryfile('robots.txt')
        end
      end
    end
  end
end

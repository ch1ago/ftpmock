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

    describe 'put methods' do
      describe 'put' do
        it 'fails when called before connect' do
          subject.real = double('Real')
          expect do
            subject.put('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'fails when called before connect and login' do
          subject.real = double('Real')
          subject.connect(host, port)

          expect do
            subject.put('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'properly delegates to cache and real' do
          subject.real = double('Real')
          subject.cache = double('Cache')

          subject.connect(host, port)
          subject.login(username, password)

          # cache delegation
          expect(subject.cache).to receive(:put).and_yield

          # real connection
          expect_real_to_receive_connectivity_args(subject.real)

          # real delegation
          expect(subject.real).to receive(:put)

          subject.put('robots.txt')
        end
      end

      describe 'puttextfile' do
        it 'fails when called before connect' do
          subject.real = double('Real')
          expect do
            subject.puttextfile('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'fails when called before connect and login' do
          subject.real = double('Real')
          subject.connect(host, port)

          expect do
            subject.puttextfile('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'properly delegates to cache and real' do
          subject.real = double('Real')
          subject.cache = double('Cache')

          subject.connect(host, port)
          subject.login(username, password)

          # cache delegation
          expect(subject.cache).to receive(:put).and_yield

          # real connection
          expect_real_to_receive_connectivity_args(subject.real)

          # real delegation
          expect(subject.real).to receive(:puttextfile)

          subject.puttextfile('robots.txt')
        end
      end

      describe 'putbinaryfile' do
        it 'fails when called before connect' do
          subject.real = double('Real')
          expect do
            subject.putbinaryfile('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'fails when called before connect and login' do
          subject.real = double('Real')
          subject.connect(host, port)

          expect do
            subject.putbinaryfile('robots.txt')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'properly delegates to cache and real' do
          subject.real = double('Real')
          subject.cache = double('Cache')

          subject.connect(host, port)
          subject.login(username, password)

          # cache delegation
          expect(subject.cache).to receive(:put).and_yield

          # real connection
          expect_real_to_receive_connectivity_args(subject.real)

          # real delegation
          expect(subject.real).to receive(:putbinaryfile)

          subject.putbinaryfile('robots.txt')
        end
      end
    end
  end
end

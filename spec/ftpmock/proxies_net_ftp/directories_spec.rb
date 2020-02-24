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

    describe '#chdir' do
      describe 'connectivity' do
        it 'fails when called before connect' do
          subject.real = double('Real')
          expect do
            subject.chdir('foobar')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end

        it 'fails when called before connect and login' do
          subject.real = double('Real')
          subject.connect(host, port)

          expect do
            subject.chdir('foobar')
          end.to raise_error(Net::FTPConnectionError, 'not connected')
        end
      end

      it 'properly skips real and delegates to cache when it connects' do
        subject.real = double('Real')
        subject.cache = double('Cache')

        subject.connect(host, port)
        subject.login(username, password)

        # cache delegation
        expect(subject.cache).to receive(:chdir).twice.and_return('lol')

        # real connection
        # expect_real_to_receive_connectivity_args(subject.real)

        # real delegation
        expect(subject.real).not_to receive(:chdir)

        ret = subject.chdir('OMG_THIS_WAS_SKIPPED')
        expect(ret.to_s).to eq('lol')
        expect(subject.chdir.to_s).to eq('lol')
      end

      it 'properly delegates to real and cache when it connects' do
        subject.real = double('Real')
        # subject.cache = double('Cache')

        subject.connect(host, port)
        subject.login(username, password)

        # cache delegation
        expect(subject.cache).to receive(:chdir).twice.and_return('lol')

        ret = subject.chdir('OMG_THIS_WAS_SKIPPED')
        expect(ret.to_s).to eq('lol')
        expect(subject.chdir.to_s).to eq('lol')

        # real connection
        expect_real_to_receive_connectivity_args(subject.real)

        # real delegation
        expect(subject.real).not_to receive(:chdir)
        subject._real_connect_and_login
      end
    end

    describe 'aliases' do
      it 'pwd is an alias' do
        expect(subject).to receive(:chdir)

        subject.pwd
      end

      it 'getdir is an alias' do
        expect(subject).to receive(:chdir)

        subject.getdir
      end
    end
  end
end

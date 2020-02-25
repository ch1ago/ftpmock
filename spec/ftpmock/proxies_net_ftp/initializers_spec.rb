RSpec.describe Ftpmock::NetFtpProxy do
  describe 'Initializers' do
    let(:host) { 'ftp.example.com' }
    let(:port) { 21 }
    let(:username) { 'user1' }
    let(:password) { 'changeme123' }

    def do_nothing; end

    describe '.new' do
      def new_works_with(*args)
        Ftpmock::NetFtpProxy.new(*args)
        begin
          Ftpmock::NetFtpProxy::Real.new(*args)
        rescue SocketError
          do_nothing
        end
      end

      example 'empty' do
        new_works_with
      end

      example 'host' do
        new_works_with(host)
      end

      example 'host, username, password' do
        new_works_with(host, username, password)
      end

      example 'host, username: , password: ' do
        new_works_with(host, username: username, password: password)
      end
    end

    describe '.open' do
      before do
        allow(Ftpmock::VerboseUtils).to receive(:warn)
      end

      def open_works_with(*args)
        Ftpmock::NetFtpProxy.open(*args) { |ftp| }
        begin
          Ftpmock::NetFtpProxy::Real.open(*args) { |ftp| }
        rescue SocketError
          do_nothing
        end
      end

      example 'not empty' do
        expect do
          open_works_with
        end.to raise_error(ArgumentError)
      end

      example 'host' do
        open_works_with(host)
      end

      example 'host, username, password' do
        open_works_with(host, username, password)
      end

      example 'host, username: , password: ' do
        open_works_with(host, username: username, password: password)
      end
    end
  end
end

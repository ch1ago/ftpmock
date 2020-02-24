RSpec.describe Ftpmock::NetFtpProxy do
  describe 'Connection' do
    let(:host) { 'ftp.example.com' }
    let(:port) { 21 }
    let(:username) { 'user1' }
    let(:password) { 'changeme123' }

    it 'properly sets instance variables' do
      subject.connect(host, port)
      subject.login(username, password)

      expect(subject.host).to eq(host)
      expect(subject.port).to eq(port)
      expect(subject.username).to eq(username)
      expect(subject.password).to eq(password)
    end

    it 'properly initializes an cache' do
      expect { subject.cache }.to raise_error(Net::FTPConnectionError)

      subject.connect(host, port)
      subject.login(username, password)

      expect(subject.cache).to be_a(Ftpmock::Cache)
    end

    it 'requires login be called' do
      subject.connect(host, port)
      # subject.login(username, nil)

      expect do
        subject.cache
      end.to raise_error(Net::FTPConnectionError)
    end
  end
end

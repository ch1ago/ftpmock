RSpec.describe Ftpmock::NetFtpProxy do
  describe 'Login' do
    let(:host) { 'ftp.example.com' }
    let(:port) { 21 }
    let(:username) { 'user1' }
    let(:password) { 'changeme123' }

    it 'requires connect be called before login' do
      expect do
        subject.login(username, password)
      end.to raise_error(Ftpmock::CodeError)
    end

    it 'can take two arguments' do
      subject.connect(host, port)
      subject.login(username, password)
    end

    it 'can take one argument' do
      subject.connect(host, port)
      subject.login(username)
    end

    it 'can take zero arguments' do
      subject.connect(host, port)
      subject.login
    end
  end
end

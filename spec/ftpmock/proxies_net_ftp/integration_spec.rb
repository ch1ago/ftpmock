RSpec.describe Ftpmock::NetFtpProxy do
  describe 'Integration' do
    let(:proxy) { Ftpmock::NetFtpProxy.new }
    let(:host) { '' }
    let(:port) { 21 }
    let(:username) { '' }
    let(:password) { '' }

    before do
      proxy.connect(host, port)
      proxy.login(username, password)
    end

    describe 'Ubuntu Download - University of Pittsburgh' do
      let(:host) { 'mirror.cs.pitt.edu' }

      describe 'list' do
        example 'has verbose mode messages' do
          expect_verbose_alert :green,
                               "ftpmock.cache.list ''",
                               'hit! (5 lines)'
          proxy.list
        end

        example 'returns lines' do
          ret = proxy.list
          expect(ret.size).to eq(5)
        end

        example 'creates a list.yml file' do
          proxy.list
          expect(File).to exist('spec/records/mirror-cs-pitt-edu_21__/list.yml')
        end

        example 'chdir then list' do
          expect_verbose_alert :green,
                               "ftpmock.cache.chdir '/ubuntu'",
                               "changed from '' to 'ubuntu'"
          expect_verbose_alert :green,
                               "ftpmock.cache.list '', chdir: 'ubuntu'",
                               'hit! (3 lines)'
          proxy.chdir('/ubuntu')
          ret = proxy.list
          expect(ret.size).to eq(3)
        end
      end
    end

    describe 'Ubuntu Download - Rochester Institute of Technology' do
      let(:host) { 'mirrors.rit.edu' }

      describe 'list' do
        example 'has verbose mode messages' do
          expect_verbose_alert :green,
                               "ftpmock.cache.list ''",
                               'hit! (61 lines)'
          proxy.list
        end

        example 'returns lines' do
          ret = proxy.list
          expect(ret.size).to eq(61)
        end

        example 'creates a list.yml file' do
          proxy.list
          expect(File).to exist('spec/records/mirror-cs-pitt-edu_21__/list.yml')
        end

        example 'chdir then list' do
          expect_verbose_alert :green,
                               "ftpmock.cache.chdir '/ubuntu'",
                               "changed from '' to 'ubuntu'"
          expect_verbose_alert :green,
                               "ftpmock.cache.list '', chdir: 'ubuntu'",
                               'hit! (6 lines)'
          proxy.chdir('/ubuntu')
          ret = proxy.list
          expect(ret.size).to eq(6)
        end
      end
    end
  end
end

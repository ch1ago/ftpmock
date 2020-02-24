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

      describe 'get' do
        let(:remotefile) { '/ubuntu/releases/robots.txt' }
        let(:localfile) { 'tmp/robots-pitt-edu.txt' }

        example 'verbose messages' do
          expect_verbose_alert :green,
                               "ftpmock.cache.get '/ubuntu/releases/robots.txt'",
                               'hit! (tmp/robots-pitt-edu.txt)'
          proxy.get(remotefile, localfile)
        end

        example 'localfile should exist' do
          proxy.get(remotefile, localfile)
          expect(File).to exist(localfile)
        end

        example 'expect the real library not to receive get' do
          expect(proxy.real).not_to receive(:get)
          proxy.get(remotefile, localfile)
        end

        example 'expect proxy.cache receive get with the right args' do
          args = [remotefile, localfile]
          expect(proxy.cache).to receive(:get).with(*args).and_return(true)
          proxy.get(remotefile, localfile)
        end

        example 'expect GetHelper receive read with the right args' do
          args = [Pathname('spec/records/mirror-cs-pitt-edu_21__'), nil, remotefile, localfile]
          expect(Ftpmock::GetHelper).to receive(:read).with(*args).and_return(true)
          proxy.get(remotefile, localfile)
        end

        example 'expects GetHelper to have cached the file on the expected location' do
          proxy.get(remotefile, localfile)
          expect(File).to exist('spec/records/mirror-cs-pitt-edu_21__/get/ubuntu-releases-robots_txt')
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

      describe 'get' do
        let(:remotefile) { '/ubuntu-releases/robots.txt' }
        let(:localfile) { 'tmp/robots-rit-edu.txt' }

        example 'verbose messages' do
          expect_verbose_alert :green,
                               "ftpmock.cache.get '/ubuntu-releases/robots.txt'",
                               'hit! (tmp/robots-rit-edu.txt)'
          proxy.get(remotefile, localfile)
        end

        example 'localfile should exist' do
          proxy.get(remotefile, localfile)
          expect(File).to exist(localfile)
        end

        example 'expect the real library not to receive get' do
          expect(proxy.real).not_to receive(:get)
          proxy.get(remotefile, localfile)
        end

        example 'expect proxy.cache receive get with the right args' do
          args = [remotefile, localfile]
          expect(proxy.cache).to receive(:get).with(*args).and_return(true)
          proxy.get(remotefile, localfile)
        end

        example 'expect GetHelper receive read with the right args' do
          args = [Pathname('spec/records/mirrors-rit-edu_21__'), nil, remotefile, localfile]
          expect(Ftpmock::GetHelper).to receive(:read).with(*args).and_return(true)
          proxy.get(remotefile, localfile)
        end

        example 'expects GetHelper to have cached the file on the expected location' do
          proxy.get(remotefile, localfile)
          expect(File).to exist('spec/records/mirrors-rit-edu_21__/get/ubuntu-releases-robots_txt')
        end
      end
    end
  end
end

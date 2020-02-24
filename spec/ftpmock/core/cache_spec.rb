RSpec.describe Ftpmock::Cache do
  let(:host) { 'cache_test' }
  let(:port) { 21 }
  let(:username) { 'a' }
  let(:password) { 'b' }
  let(:credentials) { [host, port, username, password] }
  let(:cache) { Ftpmock::Cache.new(Ftpmock.configuration, credentials) }

  describe 'Instance Methods' do
    describe 'path' do
      it 'is a Pathname' do
        expect(cache.path).to be_a(Pathname)
      end

      it 'joins all credentials' do
        expect(cache.path.to_s).to eq('spec/records/cache_test_21_a_b')
      end
    end

    describe 'chdir' do
      it 'delegates to PathHelper' do
        # Then 'it delegates'
        expect(Ftpmock::PathHelper).to receive(:join).with(nil, 'foo')

        # When 'I run cache.chdir'
        cache.chdir('foo')
      end

      it 'can be read as well' do
        # Given 'no chdir was set'
        expect(cache.chdir.to_s).to eq('')

        # When 'I run cache.chdir with an argument'
        cache.chdir('foo')

        # Then 'the chdir is changed'
        expect(cache.chdir.to_s).to eq('foo')
      end

      it 'can change cumulatively' do
        # Given 'a starting chdir'
        cache.chdir('foo')
        expect(cache.chdir.to_s).to eq('foo')

        # When 'I run cache.chdir with an argument'
        cache.chdir('bar')

        # Then 'the chdir is changed'
        expect(cache.chdir.to_s).to eq('foo/bar')
      end
    end

    describe 'list' do
      describe 'if cache hits' do
        before do
          expected_args = [kind_of(Pathname), nil, 'foo']
          expect(Ftpmock::ListHelper).to receive(:read)
            .with(*expected_args)
            .and_return([123])
        end

        it 'skips the block' do
          has_block_run = false

          # When 'I run cache.list'
          cache.list('foo') { has_block_run = true }

          # Then 'it skips the block'
          expect(has_block_run).to eq(false)
        end

        it 'returns the from cache' do
          ret = cache.list('foo') { [456] }
          expect(ret).to eq([123])
        end

        it 'skips writing to cache' do
          expect(Ftpmock::ListHelper).not_to receive(:write)
          cache.list('foo') { [456] }
        end
      end

      describe 'if cache misses' do
        before do
          expected_args = [kind_of(Pathname), nil, 'foo']
          expect(Ftpmock::ListHelper).to receive(:read)
            .with(*expected_args)
            .and_return(nil)
        end

        it 'runs the block, returns from block, writes to cache' do
          has_block_run = false
          # Then 'ListHelper should receive :write'
          expected_args = [kind_of(Pathname), nil, 'foo', [:the_block_result]]
          expect(Ftpmock::ListHelper).to receive(:write)
            .with(*expected_args)

          ret = cache.list('foo') do
            has_block_run = true
            [:the_block_result]
          end
          expect(ret).to eq([:the_block_result])

          # Then 'block should run'
          expect(has_block_run).to eq(true)
        end
      end
    end

    describe 'get' do
      let(:localfile) { "tmp/cache_get_#{SecureRandom.uuid}" }
      describe 'if cache is found' do
        before do
          # Given 'GetHelper.read returns true'
          expect(Ftpmock::GetHelper).to receive(:read).and_return(true)
        end

        it 'skips the block' do
          block_has_run = false

          # When 'I run cache.get(remotefile)'
          cache.get('remotefile', localfile) do
            block_has_run = true
          end

          # Then 'it should not yield the block'
          expect(block_has_run).to eq(false)
        end

        it 'skips writing to cache' do
          # Then 'GetHelper should not receive :write'
          expect(Ftpmock::GetHelper).not_to receive(:write)

          # When 'I run cache.get(remotefile)'
          cache.get('remotefile', localfile) do
          end
        end
      end

      describe 'if cache misses' do
        before do
          # Given 'GetHelper.read returns false'
          expect(Ftpmock::GetHelper).to receive(:read).and_return(false)
        end

        it 'runs the block and verifies remotefile fetching' do
          expect(Ftpmock::GetHelper).to receive(:fetched?).and_return(true)
          expect(Ftpmock::GetHelper).to receive(:write)

          block_has_run = true

          # When 'I run cache.get(remotefile)'
          cache.get('remotefile', localfile) do
            block_has_run = true
          end

          # Then 'it should yield the block'
          expect(block_has_run).to eq(true)
        end

        describe 'if remotefile was not fetched' do
          before do
            # Given 'GetHelper.fetched? returns false'
            expect(Ftpmock::GetHelper).to receive(:fetched?).and_return(false)
          end

          it 'fails' do
            # Then 'an error should be raised'
            expect do
              # When 'I run cache.get(remotefile)'
              cache.get('remotefile', localfile) do
              end
            end.to raise_error(Ftpmock::GetNotFetched)
          end
        end

        describe 'if remotefile was fetched' do
          before do
            # Given 'GetHelper.fetched? returns false'
            expect(Ftpmock::GetHelper).to receive(:fetched?).and_return(true)
          end

          it 'writes to cache' do
            # Then 'GetHelper should receive :write'
            expect(Ftpmock::GetHelper).to receive(:write)

            # When 'I run cache.get(remotefile)'
            cache.get('remotefile', localfile) do
            end
          end
        end
      end
    end
  end
end

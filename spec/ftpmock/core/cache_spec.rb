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
  end
end

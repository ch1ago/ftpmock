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
  end
end

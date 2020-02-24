RSpec.describe 'Helpers' do
  describe Ftpmock::ListHelper do
    it 'passes a sequence of tests for multiple files' do
      path_a = 'tmp/helpers_list_helper_a'
      path_b = 'tmp/helpers_list_helper_b'
      FileUtils.rm_rf(path_a)
      FileUtils.rm_rf(path_b)

      chdir = nil

      expect(subject.read(path_a, chdir, 'foo')).to eq(nil)
      expect(subject.read(path_a, chdir, 'bar')).to eq(nil)

      expect(subject.read(path_b, chdir, 'foo')).to eq(nil)
      expect(subject.read(path_b, chdir, 'bar')).to eq(nil)

      expect(subject.write(path_a, chdir, 'foo', '123')).to eq(true)
      expect(subject.write(path_b, chdir, 'foo', '456')).to eq(true)

      expect(subject.read(path_a, chdir, 'foo')).to eq('123')
      expect(subject.read(path_a, chdir, 'bar')).to eq(nil)

      expect(subject.read(path_b, chdir, 'foo')).to eq('456')
      expect(subject.read(path_b, chdir, 'bar')).to eq(nil)
    end
  end
end

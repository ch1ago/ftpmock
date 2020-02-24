RSpec.describe 'Helpers' do
  describe Ftpmock::PutHelper do
    describe '#exist?' do
      it 'delegates to File.exist?' do
        expect(File).to receive(:exist?).with('foo')
        subject.exist?('foo')
      end
    end

    describe '#write & #compare' do
      let(:cache_path_a) { Pathname('tmp/put_helper_cache/a') }
      let(:local_path_a) { 'tmp/put_helper_local/a' }
      let(:localfile_a_f1) { "#{local_path_a}/f1.txt" }
      let(:remotefile_f1) { 'f1.txt' }

      it 'passes a sequence of tests for a single file' do
        FileUtils.rm_rf('tmp/put_helper_cache')
        FileUtils.rm_rf('tmp/put_helper_local')
        FileUtils.mkdir_p('tmp/put_helper_local/a')
        FileUtils.mkdir_p('tmp/put_helper_local/b')

        File.write(localfile_a_f1, 'xyz')
        expect(subject_compare).to eq([])
        subject.write(cache_path_a, localfile_a_f1, remotefile_f1)
        expect(subject_compare).to eq([])

        File.write(localfile_a_f1, 'abc')
        diff = [
          "\e[31m-abc\e[0m",
          '\\ No newline at end of file',
          "\e[32m+xyz\e[0m",
          '\\ No newline at end of file'
        ]
        expect(subject_compare).to eq(diff)
        subject.write(cache_path_a, localfile_a_f1, remotefile_f1)
        expect(subject_compare).to eq([])
      end

      def subject_compare
        subject.compare(cache_path_a, localfile_a_f1, remotefile_f1)
      end
    end
  end
end

RSpec.describe 'Helpers' do
  describe Ftpmock::GetHelper do
    def recreate_path(path)
      FileUtils.rm_rf(path)
      FileUtils.mkdir_p(path)
    end

    describe 'read' do
      before do
        recreate_path('tmp/helpers_get_helper_cache')
        recreate_path('tmp/helpers_get_helper_local')

        @cached_a = Pathname('tmp/helpers_get_helper_cache/a')
        @local_a = Pathname('tmp/helpers_get_helper_local/a')
      end

      describe 'having chdir = nil' do
        before do
          @chdir = nil
        end

        it 'returns false if remotefile cannot be found locally cached' do
          args = [@cached_a, @chdir, 'f1.txt', "#{@local_a}/f1.txt"]
          ret = subject.read(*args)
          expect(ret).to eq(false)
        end

        it 'returns true if remotefile can be found locally cached' do
          FileUtils.mkdir_p(@local_a)
          File.write("#{@local_a}/f2.txt", 'I exist')

          args = [@cached_a, @chdir, 'f2.txt', "#{@local_a}/f2.txt"]
          ret = subject.read(*args)
          expect(ret).to eq(true)
        end
      end

      describe "having chdir = 'foo'" do
        before do
          @chdir = 'foo'
        end

        it 'returns false if remotefile cannot be found locally cached' do
          args = [@cached_a, @chdir, 'f3.txt', "#{@local_a}/foo/f3.txt"]
          ret = subject.read(*args)
          expect(ret).to eq(false)
        end

        it 'returns true if remotefile can be found locally cached' do
          FileUtils.mkdir_p("#{@local_a}/foo")
          File.write("#{@local_a}/foo/f4.txt", 'I exist')

          args = [@cached_a, @chdir, 'f4.txt', "#{@local_a}/foo/f4.txt"]
          ret = subject.read(*args)
          expect(ret).to eq(true)
        end
      end
    end

    describe 'write' do
      before do
        recreate_path('tmp/helpers_get_helper_cache')
        recreate_path('tmp/helpers_get_helper_local')

        @cached_a = Pathname('tmp/helpers_get_helper_cache/a')
        @local_a = Pathname('tmp/helpers_get_helper_local/a')
      end

      describe 'having chdir = nil' do
        before do
          @chdir = nil
        end

        it 'returns false if localfile cannot be found' do
          args = [@cached_a, @chdir, 'f1.txt', "#{@local_a}/f1.txt"]
          ret = subject.write(*args)
          expect(ret).to eq(false)
        end

        it 'returns true if localfile can be found' do
          FileUtils.mkdir_p(@local_a)
          File.write("#{@local_a}/f2.txt", 'I exist')

          args = [@cached_a, @chdir, 'f2.txt', "#{@local_a}/f2.txt"]
          ret = subject.write(*args)
          expect(ret).to eq(true)
        end
      end

      describe "having chdir = 'foo'" do
        before do
          @chdir = 'foo'
        end

        it 'returns false if localfile cannot be found' do
          args = [@cached_a, @chdir, 'f3.txt', "#{@local_a}/foo/f3.txt"]
          ret = subject.write(*args)
          expect(ret).to eq(false)
        end

        it 'returns true if localfile can be found' do
          FileUtils.mkdir_p("#{@local_a}/foo")
          File.write("#{@local_a}/foo/f4.txt", 'I exist')

          args = [@cached_a, @chdir, 'f4.txt', "#{@local_a}/foo/f4.txt"]
          ret = subject.write(*args)
          expect(ret).to eq(true)
        end
      end
    end
  end
end

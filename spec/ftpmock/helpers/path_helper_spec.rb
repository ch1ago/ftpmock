RSpec.describe 'Helpers' do
  describe Ftpmock::PathHelper do
    describe '#clean' do
      it 'returns a Pathname' do
        expect(subject.clean('foo')).to be_a(Pathname)
      end

      it 'works' do
        expect(subject.clean('foo').to_s).to eq('foo')
        expect(subject.clean('foo/../bar').to_s).to eq('bar')
      end
    end

    describe '#join' do
      it 'returns a Pathname' do
        expect(subject.join('foo', 'bar')).to be_a(Pathname)
      end

      it 'works with nil' do
        expect_join_to_eq('foo', nil, 'foo')
        expect_join_to_eq('foo/bar', nil, 'foo/bar')
        expect_join_to_eq(nil, 'foo', 'foo')
        expect_join_to_eq(nil, 'foo/bar', 'foo/bar')
      end

      it 'works with blank first arguments' do
        expect_join_to_eq('', 'foo', 'foo')
        expect_join_to_eq('', 'foo', 'foo')
        expect_join_to_eq('', 'foo/bar', 'foo/bar')
      end

      it 'works with short first arguments' do
        expect_join_to_eq('foo', '', 'foo')
        expect_join_to_eq('foo', 'foo', 'foo/foo')
        expect_join_to_eq('foo', 'foo/bar', 'foo/foo/bar')
      end

      it 'works with long first arguments' do
        expect_join_to_eq('foo/bar', '', 'foo/bar')
        expect_join_to_eq('foo/bar', 'foo', 'foo/bar/foo')
        expect_join_to_eq('foo/bar', 'foo/bar', 'foo/bar/foo/bar')
      end

      it 'works both long arguments' do
        expect_join_to_eq('foo/bar', 'bar', 'foo/bar/bar')
        expect_join_to_eq('foo/bar', 'bar/foo', 'foo/bar/bar/foo')
        expect_join_to_eq('foo/bar', 'bar/foo/bar', 'foo/bar/bar/foo/bar')
      end

      it 'works with second absolute arguments' do
        expect_join_to_eq('foo/bar', '/', '')
        expect_join_to_eq('foo/bar', '/bar', 'bar')
      end

      it 'works with second relative arguments' do
        expect_join_to_eq('foo/bar', '/', '')
        expect_join_to_eq('foo/bar', 'bar/', 'foo/bar/bar')
      end

      it 'works with second short parenting arguments' do
        expect_join_to_eq('foo/bar', '..', 'foo')
        expect_join_to_eq('foo/bar', '/..', '..')
        expect_join_to_eq('foo/bar', '../', 'foo')
        expect_join_to_eq('foo/bar', '/../', '..')
      end

      it 'works with second long parenting arguments' do
        expect_join_to_eq('foo', '../..', '..')
        expect_join_to_eq('foo', '../../..', '../..')
      end

      def expect_join_to_eq(a, b, c)
        expect(subject.join(a, b).to_s).to eq(c)
      end
    end
  end
end

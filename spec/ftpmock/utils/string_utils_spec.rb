RSpec.describe Ftpmock::StringUtils do
  describe '#present?' do
    it 'passes a small series of tests' do
      expect(subject.present?('')).to be false
      expect(subject.present?(' ')).to be false
      expect(subject.present?('  ')).to be false
      expect(subject.present?(nil)).to be false

      expect(subject.present?(123)).to be true
      expect(subject.present?(true)).to be true
      expect(subject.present?(false)).to be true

      expect(subject.present?('x')).to be true
      expect(subject.present?(' x')).to be true
      expect(subject.present?('x ')).to be true
    end

    it 'delegates if string responds to method' do
      string = 'a'
      string.define_singleton_method(:present?) { true }
      expect(string).to receive(:present?).and_return(:mocked)

      expect(subject.present?(string)).to be :mocked
    end
  end

  describe '#parameterize' do
    it 'passes a small series of tests' do
      expect(subject.parameterize('foo')).to eq('foo')
      expect(subject.parameterize('http://foo.com/')).to eq('http-foo-com-')
      expect(subject.parameterize("\u0001")).to eq('-')
      expect(subject.parameterize("\u2000")).to eq('-')
      expect(subject.parameterize("\u9999")).to eq('-')
    end
  end
end

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

  describe '#diff' do
    before do
      @f1a = 'tmp/diffy_1a.txt'
      File.write(@f1a, "111\n222\n")

      @f1b = 'tmp/diffy_1b.txt'
      File.write(@f1b, "111\n222\n")

      @f1c = 'tmp/diffy_1c.txt'
      File.write(@f1c, "111\n222\n333\n")
    end

    after do
      File.delete @f1a
      File.delete @f1b
      File.delete @f1c
    end

    it 'returns an empty line when comparing equal files' do
      ret = Ftpmock::StringUtils.diff(@f1a, @f1b)

      expect(ret).to eq("\n")
    end

    it 'returns the proper diff when comparing different files' do
      ret = Ftpmock::StringUtils.diff(@f1a, @f1c)

      expect(ret).to eq(" 111\n 222\n\e[32m+333\e[0m\n")
    end
  end
end

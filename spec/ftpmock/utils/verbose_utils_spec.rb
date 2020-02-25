RSpec.describe Ftpmock::VerboseUtils do
  describe 'warn' do
    it 'delegates to Kernel' do
      expect(Kernel).to receive(:warn).with('string')
      subject.warn('string')
    end
  end

  describe 'puts' do
    it 'delegates to Kernel' do
      expect(Kernel).to receive(:puts).with('string')
      subject.puts('string')
    end
  end

  describe 'alert' do
    it 'delegates to Kernel' do
      expected = "\e[1;39;49mTAG -> \e[0;92;49mstring\e[0m\e[0m"
      expect(Kernel).to receive(:puts).with(expected)
      Ftpmock::VerboseUtils.alert('TAG', 'string', :green)
    end
  end
end

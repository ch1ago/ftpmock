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
end

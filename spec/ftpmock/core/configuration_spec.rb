RSpec.describe Ftpmock::Configuration do
  describe '#test_dir' do
    it "uses 'spec' for RSpec" do
      expect(subject.test_dir).to eq('spec')
    end

    it "uses 'test' otherwise" do
      expect(subject).to receive(:rspec?).and_return(false)
      expect(subject.test_dir).to eq('test')
    end
  end
end

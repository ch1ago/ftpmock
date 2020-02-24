RSpec.describe Ftpmock::ColorUtils do
  describe 'colorize' do
    it 'works with 3 colors' do
      expect(subject.colorize('A', :foo)).to eq('A')
      expect(subject.colorize('A', :red)).to eq("\e[0;91;49mA\e[0m")
      expect(subject.colorize('A', :yellow)).to eq("\e[0;93;49mA\e[0m")
      expect(subject.colorize('A', :green)).to eq("\e[0;92;49mA\e[0m")
    end
  end

  describe 'bold' do
    it 'works' do
      expect(subject.bold('A')).to eq("\e[1;39;49mA\e[0m")
    end
  end
end

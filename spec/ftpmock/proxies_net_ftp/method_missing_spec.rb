RSpec.describe Ftpmock::NetFtpProxy do
  describe 'Instance Methods' do
    describe 'method missing' do
      it 'returns nil' do
        expect(subject.lol).to eq(nil)
      end

      it 'is hit' do
        expect(subject).to receive(:method_missing)
        subject.lol
      end

      describe 'VerboseUtils delegation' do
        it 'verbose=true causes delegation' do
          configuration = double(verbose: true)
          expect(subject).to receive(:configuration).and_return(configuration)
          expect(Ftpmock::VerboseUtils).to receive(:warn)
          subject.lol
        end

        it 'verbose=false skips delegation' do
          configuration = double(verbose: false)
          expect(subject).to receive(:configuration).and_return(configuration)
          expect(Ftpmock::VerboseUtils).not_to receive(:warn)
          subject.lol
        end
      end
    end
  end
end

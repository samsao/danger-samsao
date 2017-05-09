require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao

        allow(@plugin.github).to receive(:branch_for_head).and_return('something')
        allow(@plugin.github).to receive(:pr_title).and_return('Something')
      end

      describe 'trivial_change?' do
        ['#trivial', '#typo', '#typos'].each do |marker|
          it "returns true when PR title contains #{marker} at the end" do
            allow(@plugin.github).to receive(:pr_title).and_return("Marker at the end #{marker}")

            expect(@plugin.trivial_change?).to be(true)
          end

          it "returns true when PR title contains #{marker} at the start" do
            allow(@plugin.github).to receive(:pr_title).and_return("#{marker} Marker at the start")

            expect(@plugin.trivial_change?).to be(true)
          end

          it "returns true when PR title contains #{marker} in the middle" do
            allow(@plugin.github).to receive(:pr_title).and_return("Marker in #{marker} the middle")

            expect(@plugin.trivial_change?).to be(true)
          end
        end

        it 'returns false no trivial marker(s) in PR title' do
          allow(@plugin.github).to receive(:pr_title).and_return('Something')

          expect(@plugin.trivial_change?).to be(false)
        end
      end
    end
  end
end

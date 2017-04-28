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

      describe 'misc helper trivial_change?' do
        it 'returns true when PR title contains #trivial at the end' do
          allow(@plugin.github).to receive(:pr_title).and_return('Trivial at the end #trivial')

          expect(@plugin.trivial_change?).to be(true)
        end

        it 'returns true when PR title contains #trivial at the start' do
          allow(@plugin.github).to receive(:pr_title).and_return('#trivial Trivial at the start')

          expect(@plugin.trivial_change?).to be(true)
        end

        it 'returns true when PR title contains #trivial in the middle' do
          allow(@plugin.github).to receive(:pr_title).and_return('Trivial in #trivial the middle')

          expect(@plugin.trivial_change?).to be(true)
        end

        it 'returns true when branch is a trivial branch' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('trivial/a')

          expect(@plugin.trivial_change?).to be(true)
        end

        it 'returns true when branch is a trivial branch and PR include trivial' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('trivial/a')
          allow(@plugin.github).to receive(:pr_title).and_return('#trivial')

          expect(@plugin.trivial_change?).to be(true)
        end

        it 'returns false when not trivial branch and no #trivial marker in PR title' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.github).to receive(:pr_title).and_return('Something')

          expect(@plugin.trivial_change?).to be(false)
        end
      end
    end
  end
end

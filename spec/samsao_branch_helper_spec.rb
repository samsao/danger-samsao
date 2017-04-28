require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'branch helpers' do
        it 'supports feature_branch? correctly' do
          data_set = [
            { branch: 'feature/a', expected: true },
            { branch: 'fix/a', expected: false },
            { branch: 'random', expected: false },
          ]

          data_set.each do |data|
            allow(@plugin.github).to receive(:branch_for_head).and_return(data[:branch])
            expect(@plugin.feature_branch?).to be(data[:expected])
          end
        end

        it 'supports fix_branch? correctly' do
          data_set = [
            { branch: 'feature/a', expected: false },
            { branch: 'fix/a', expected: true },
            { branch: 'random', expected: false },
          ]

          data_set.each do |data|
            allow(@plugin.github).to receive(:branch_for_head).and_return(data[:branch])
            expect(@plugin.fix_branch?).to be(data[:expected])
          end
        end

        it 'supports release_branch? correctly' do
          data_set = [
            { branch: 'release/a', expected: true },
            { branch: 'fix/a', expected: false },
            { branch: 'random', expected: false },
          ]

          data_set.each do |data|
            allow(@plugin.github).to receive(:branch_for_head).and_return(data[:branch])
            expect(@plugin.release_branch?).to be(data[:expected])
          end
        end

        it 'supports trivial_branch? correctly' do
          data_set = [
            { branch: 'trivial/a', expected: true },
            { branch: 'fix/a', expected: false },
            { branch: 'random', expected: false },
          ]

          data_set.each do |data|
            allow(@plugin.github).to receive(:branch_for_head).and_return(data[:branch])
            expect(@plugin.trivial_branch?).to be(data[:expected])
          end
        end
      end
    end
  end
end

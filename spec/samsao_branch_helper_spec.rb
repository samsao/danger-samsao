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
            { branch: '2.0.0/feature/a', expected: true },
            { branch: 'other_app-name/feature/a', expected: true },
            { branch: 'something/something-else/feature/a', expected: false },
            { branch: 'fix/a', expected: false },
            { branch: 'feature/', expected: false },
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
            { branch: 'bugfix/a', expected: true },
            { branch: 'hotfix/a', expected: true },
            { branch: 'warmfix/a', expected: true },
            { branch: 'coldfix/a', expected: true },
            { branch: '2.0.0/fix/a', expected: true },
            { branch: 'other_app-name/fix/a', expected: true },
            { branch: 'something/something-else/fix/a', expected: false },
            { branch: 'otherfix/a', expected: false },
            { branch: 'fix/', expected: false },
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
            { branch: '2.0.0/release/a', expected: true },
            { branch: 'other_app-name/release/a', expected: true },
            { branch: 'something/something-else/release/a', expected: false },
            { branch: 'fix/a', expected: false },
            { branch: 'release/', expected: false },
            { branch: 'random', expected: false },
          ]

          data_set.each do |data|
            allow(@plugin.github).to receive(:branch_for_head).and_return(data[:branch])
            expect(@plugin.release_branch?).to be(data[:expected])
          end
        end

        it 'supports support_branch? correctly' do
          data_set = [
            { branch: 'support/a', expected: true },
            { branch: '2.0.0/support/a', expected: true },
            { branch: 'other_app-name/support/a', expected: true },
            { branch: 'something/something-else/support/a', expected: false },
            { branch: 'fix/a', expected: false },
            { branch: 'support/', expected: false },
            { branch: 'random', expected: false },
          ]

          data_set.each do |data|
            allow(@plugin.github).to receive(:branch_for_head).and_return(data[:branch])
            expect(@plugin.support_branch?).to be(data[:expected])
          end
        end
      end
    end
  end
end

require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
        @must_have_single_commit = 'Your feature branch should have a single commit but found 2, squash them together!'
      end

      describe 'feature branch commits' do
        it 'continues on feature branch and one commit' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.git).to receive(:commits).and_return(['sha1'])

          @plugin.check_non_single_commit_feature

          expect(@dangerfile).to have_no_error
        end

        it 'continues on non-feature branch and multiple commits' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('fix/a')
          allow(@plugin.git).to receive(:commits).and_return(['sha1', 'sha2'])

          @plugin.check_non_single_commit_feature

          expect(@dangerfile).to have_no_error
        end

        it 'fails on feature branch and multiple commits' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.git).to receive(:commits).and_return(['sha1', 'sha2'])

          @plugin.check_non_single_commit_feature

          expect(@dangerfile).to have_error(@must_have_single_commit)
        end
      end
    end
  end
end

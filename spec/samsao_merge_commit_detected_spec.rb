require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
        @merge_commits_detected = 'Some merge commits were detected, you must use rebase to sync with base branch.'

        allow(@plugin.github).to receive(:branch_for_base).and_return('develop')
      end

      describe 'merge commit detected' do
        it 'continues when no commits' do
          allow(@plugin.git).to receive(:commits).and_return([])

          @plugin.check_merge_commit_detected

          expect(@dangerfile).to have_no_error
        end

        it 'continues when no merge commits' do
          allow(@plugin.git).to receive(:commits).and_return([
            commit('One'),
            commit('two'),
          ])

          @plugin.check_merge_commit_detected

          expect(@dangerfile).to have_no_error
        end

        it 'continues when one merge commits' do
          allow(@plugin.git).to receive(:commits).and_return([
            commit('one'),
            commit("Merge branch 'develop'"),
          ])

          @plugin.check_merge_commit_detected

          expect(@dangerfile).to have_error(@merge_commits_detected)
        end

        it 'continues on multiple merge commits' do
          allow(@plugin.git).to receive(:commits).and_return([
            commit("Merge branch 'develop'"),
            commit("Merge branch 'develop'"),
          ])

          @plugin.check_merge_commit_detected

          expect(@dangerfile).to have_error(@merge_commits_detected)
        end

        it 'uses correctly github base branch' do
          allow(@plugin.github).to receive(:branch_for_base).and_return('test')
          allow(@plugin.git).to receive(:commits).and_return([
            commit("Merge branch 'test'"),
          ])

          @plugin.check_merge_commit_detected

          expect(@dangerfile).to have_error(@merge_commits_detected)
        end
      end
    end
  end
end

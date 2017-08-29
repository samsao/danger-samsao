require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'check fix branch jira issue number' do
        it 'continues on trivial change' do
          allow(@plugin).to receive(:trivial_change?).and_return(true)

          @plugin.check_fix_jira_issue_number

          expect(@dangerfile).to have_no_error
        end

        it 'continues on feature branch' do
          allow(@plugin).to receive(:trivial_change?).and_return(false)
          allow(@plugin).to receive(:fix_branch?).and_return(false)

          @plugin.check_fix_jira_issue_number

          expect(@dangerfile).to have_no_error
        end

        it 'fails on missing jira project key' do
          allow(@plugin).to receive(:trivial_change?).and_return(false)
          allow(@plugin).to receive(:fix_branch?).and_return(true)

          @plugin.check_fix_jira_issue_number

          expect(@dangerfile).to have_error('Your Danger config is missing a `jira_project_key` value.')
        end

        it 'fails on commit with no issue number' do
          jira_project_key = 'VER'
          commit_message = 'Bad message'
          commit_sha = '48ffffb'
          commit_id = "#{commit_sha} ('#{commit_message}')"

          @plugin.config do
            jira_project_key jira_project_key
          end

          allow(@plugin.github).to receive(:branch_for_head).and_return('fix/a')
          allow(@plugin.github).to receive(:pr_title).and_return('Title')
          allow(@plugin.git).to receive(:commits).and_return([commit(commit_message, commit_sha)])

          @plugin.check_fix_jira_issue_number

          message = "The commit message #{commit_id} should contain JIRA issue number between square brackets"\
                    " (i.e. [#{jira_project_key}-XXX]), multiple allowed (i.e. [#{jira_project_key}-XXX,"\
                    " #{jira_project_key}-YYY, #{jira_project_key}-ZZZ])"

          expect(@dangerfile).to have_warning(message)
        end

        it 'continue on multiple commits with issue number' do
          jira_project_key = 'VER'

          first_commit = commit("[#{jira_project_key}-123]", '48ffffb')
          second_commit = commit("[#{jira_project_key}-124, #{jira_project_key}-125]", '48ffffb')

          @plugin.config do
            jira_project_key jira_project_key
          end

          allow(@plugin.github).to receive(:branch_for_head).and_return('fix/a')
          allow(@plugin.github).to receive(:pr_title).and_return('Title')
          allow(@plugin.git).to receive(:commits).and_return([first_commit, second_commit])

          @plugin.check_fix_jira_issue_number

          expect(@dangerfile).to have_no_warning
        end
      end
    end
  end
end

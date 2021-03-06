require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'check feature branch jira issue number' do
        it 'continues on trivial change' do
          allow(@plugin).to receive(:trivial_change?).and_return(true)

          @plugin.check_feature_jira_issue_number

          expect(@dangerfile).to have_no_error
        end

        it 'continues on fix branch' do
          allow(@plugin).to receive(:trivial_change?).and_return(false)
          allow(@plugin).to receive(:feature_branch?).and_return(false)

          @plugin.check_feature_jira_issue_number

          expect(@dangerfile).to have_no_error
        end

        it 'fails on missing jira project key' do
          allow(@plugin).to receive(:trivial_change?).and_return(false)
          allow(@plugin).to receive(:feature_branch?).and_return(true)

          @plugin.check_feature_jira_issue_number

          expect(@dangerfile).to have_error('Your Danger config is missing a `jira_project_key` value.')
        end

        it 'continue on branch with issue number' do
          jira_project_key = 'VER'

          @plugin.config do
            jira_project_key jira_project_key
          end

          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.github).to receive(:pr_title).and_return("[#{jira_project_key}-123] Title")

          @plugin.check_feature_jira_issue_number

          expect(@dangerfile).to have_no_error
        end

        it 'fails on branch with no issue number' do
          jira_project_key = 'VER'
          message = 'The PR title must starts with JIRA issue number between square brackets'\
                    " (i.e. [#{jira_project_key}-XXX])."

          @plugin.config do
            jira_project_key jira_project_key
          end

          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.github).to receive(:pr_title).and_return('Title')

          @plugin.check_feature_jira_issue_number

          expect(@dangerfile).to have_error(message)
        end
      end
    end
  end
end

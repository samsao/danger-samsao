require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'jira_project_key? helper' do
        it "doesn't have project key" do
          expect(@plugin.jira_project_key?).to eq(false)
        end

        it 'has jira project key' do
          jira_project_key = 'VER'

          @plugin.config do
            jira_project_key jira_project_key
          end

          expect(@plugin.jira_project_key?).to eq(true)
        end

        it 'has invalid jira project key' do
          jira_project_key = '123'
          message = "Jira project key '#{jira_project_key}' is invalid, must be uppercase and"\
                    ' between 1 and 10 characters'

          expect { @plugin.config { jira_project_key jira_project_key } }.to raise_error(message)
          expect(@plugin.jira_project_key?).to eq(false)
        end
      end
    end
  end
end

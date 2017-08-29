require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
        @message = 'The PR description should have the acceptance criteria in the body.'
      end

      describe 'check acceptance criteria' do
        it 'continues on fix branch' do
          allow(@plugin).to receive(:feature_branch?).and_return(false)

          @plugin.check_acceptance_criteria

          expect(@dangerfile).to have_no_warning
          expect(@dangerfile).to have_no_error
        end

        it 'warns if acceptance criteria is missing' do
          allow(@plugin).to receive(:feature_branch?).and_return(true)
          allow(@plugin.github).to receive(:pr_body).and_return('Bad example')

          @plugin.check_acceptance_criteria

          expect(@dangerfile).to have_warning(@message)
          expect(@dangerfile).to have_no_error
        end

        it 'fails if report level specified' do
          allow(@plugin).to receive(:feature_branch?).and_return(true)
          allow(@plugin.github).to receive(:pr_body).and_return('Bad example')

          @plugin.check_acceptance_criteria :fail

          expect(@dangerfile).to have_error(@message)
          expect(@dangerfile).to have_no_warning
        end

        it 'continues if contains acceptance criteria' do
          allow(@plugin).to receive(:feature_branch?).and_return(true)
          allow(@plugin.github).to receive(:pr_body).and_return('acceptance criteria : Good example')

          @plugin.check_acceptance_criteria

          expect(@dangerfile).to have_no_warning
          expect(@dangerfile).to have_no_error
        end
      end
    end
  end
end

require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
        @message = 'The PR should have at least one label added to it.'
      end

      describe 'check labels PR' do
        it 'continues if pr has labels' do
          allow(@plugin.github).to receive(:pr_labels).and_return(['web', 'mobile', 'backend'])

          @plugin.check_label_pr

          expect(@dangerfile).to have_no_warning
          expect(@dangerfile).to have_no_error
        end

        it 'fails if labels missing' do
          allow(@plugin.github).to receive(:pr_labels).and_return([])

          @plugin.check_label_pr

          expect(@dangerfile).to have_error(@message)
          expect(@dangerfile).to have_no_warning
        end

        it 'warns if report level specified' do
          allow(@plugin.github).to receive(:pr_labels).and_return([])

          @plugin.check_label_pr :warn

          expect(@dangerfile).to have_warning(@message)
          expect(@dangerfile).to have_no_error
        end

        it 'fails if labels is nil' do
          allow(@plugin.github).to receive(:pr_labels).and_return(nil)

          @plugin.check_label_pr

          expect(@dangerfile).to have_error(@message)
          expect(@dangerfile).to have_no_warning
        end
      end
    end
  end
end

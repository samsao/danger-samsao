require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
        @work_in_progress = 'Do not merge, PR is a work in progess [WIP]!'

        allow(@plugin.github).to receive(:branch_for_head).and_return('something')
        allow(@plugin.github).to receive(:pr_title).and_return('Something')
      end

      describe 'warn_when_work_in_progess_pr?' do
        it 'warns when PR title contains [WIP] at the end' do
          allow(@plugin.github).to receive(:pr_title).and_return('Marker at the end [WIP]')

          @plugin.warn_when_work_in_progess_pr

          expect(@dangerfile).to have_warning(@work_in_progress)
        end

        it 'warns when PR title contains [WIP] at the start' do
          allow(@plugin.github).to receive(:pr_title).and_return('[WIP] Marker at start')

          @plugin.warn_when_work_in_progess_pr

          expect(@dangerfile).to have_warning(@work_in_progress)
        end

        it 'warns when PR title contains [WIP] in the middle' do
          allow(@plugin.github).to receive(:pr_title).and_return('Marker in [WIP] the middle')

          @plugin.warn_when_work_in_progess_pr

          expect(@dangerfile).to have_warning(@work_in_progress)
        end

        it 'continues when PR title does not contain [WIP] marker' do
          allow(@plugin.github).to receive(:pr_title).and_return('A WIP PR')

          @plugin.warn_when_work_in_progess_pr

          expect(@dangerfile).to have_no_warning
        end
      end
    end
  end
end

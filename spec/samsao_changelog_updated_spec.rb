require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
        @changelog_needs_update = 'You did a change without updating CHANGELOG file!'

        allow(@plugin.github).to receive(:pr_title).and_return('Something')
      end

      describe 'changelog updated' do
        it 'continues on support branch' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('support/a')

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_no_error
        end

        ['fix', 'bugfix', 'hotfix', 'feature', 'release'].each do |branch|
          it "continues on #{branch} branch and CHANGELOG updated" do
            allow(@plugin.github).to receive(:branch_for_head).and_return("#{branch}/a")
            allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.md'])

            @plugin.fail_when_changelog_update_missing

            expect(@dangerfile).to have_no_error
          end

          it "fails on #{branch} branch and CHANGELOG not updated" do
            allow(@plugin.github).to receive(:branch_for_head).and_return("#{branch}/a")
            allow(@plugin.git).to receive(:modified_files).and_return([])

            @plugin.fail_when_changelog_update_missing

            expect(@dangerfile).to have_error(@changelog_needs_update)
          end
        end

        it 'accepts customized changelogs path' do
          @plugin.config do
            changelogs 'CHANGELOG.yml'
          end

          allow(@plugin.github).to receive(:branch_for_head).and_return('fix/a')
          allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.yml'])

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_no_error
        end

        it 'accepts multiple changelog paths' do
          @plugin.config do
            changelogs 'CHANGELOG.yml', 'web/CHANGELOG.md'
          end

          allow(@plugin.github).to receive(:branch_for_head).and_return('fix/a')
          allow(@plugin.git).to receive(:modified_files).and_return(['web/CHANGELOG.md'])

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_no_error
        end

        it 'continues on trivial_change and CHANGELOG not updated' do
          allow(@plugin).to receive(:trivial_change?).and_return(true)
          allow(@plugin.git).to receive(:modified_files).and_return([])

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_no_error
        end

        it 'continues on support_branch within application project and CHANGELOG not updated' do
          @plugin.config do
            project_type :application
          end

          allow(@plugin).to receive(:support_branch?).and_return(true)
          allow(@plugin.git).to receive(:modified_files).and_return([])

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_no_error
        end

        it 'fails on support_branch within library project and CHANGELOG not updated' do
          @plugin.config do
            project_type :library
          end

          allow(@plugin).to receive(:support_branch?).and_return(true)
          allow(@plugin.git).to receive(:modified_files).and_return([])

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_error(@changelog_needs_update)
        end
      end
    end
  end
end

require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao

        allow(@plugin.github).to receive(:pr_title).and_return('Something')
      end

      describe 'changelog updated' do
        it 'continues on non-feature & non-fix branch' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('trivial/a')

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_no_error
        end

        it 'continues on feature branch and CHANGELOG updated' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.md'])

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_no_error
        end

        it 'continues on fix branch and CHANGELOG updated' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('fix/a')
          allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.md'])

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_no_error
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

        it 'fails on feature branch and CHANGELOG not updated' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.git).to receive(:modified_files).and_return([])

          @plugin.fail_when_changelog_update_missing

          expect(@dangerfile).to have_error('You did a fix or a feature without updating CHANGELOG file!')
        end
      end
    end
  end
end

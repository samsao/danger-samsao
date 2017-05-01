require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'changelog updated' do
        it 'returns true when modified with single entry' do
          allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.md'])

          expect(@plugin.changelog_modified?('CHANGELOG.md')).to be(true)
        end

        it 'returns true when modified with multiple entries' do
          allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.yml'])

          expect(@plugin.changelog_modified?('CHANGELOG.md', 'CHANGELOG.yml')).to be(true)
        end

        it 'returns true when modified with multiple entries and multiple matches' do
          allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.yml', 'CHANGELOG.md'])

          expect(@plugin.changelog_modified?('CHANGELOG.md', 'CHANGELOG.yml')).to be(true)
        end

        it 'returns false when not matching file' do
          allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.yml'])

          expect(@plugin.changelog_modified?('CHANGELOG.md')).to be(false)
        end

        it 'uses plugin config changelogs when no arguments passed' do
          @plugin.config do
            changelogs 'CHANGELOG.md', 'CHANGELOG.yml'
          end

          allow(@plugin.git).to receive(:modified_files).and_return(['CHANGELOG.yml'])

          expect(@plugin.changelog_modified?).to be(true)
        end
      end
    end
  end
end

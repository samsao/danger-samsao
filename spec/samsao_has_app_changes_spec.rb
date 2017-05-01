require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao

        allow(@plugin.github).to receive(:branch_for_head).and_return('something')
        allow(@plugin.github).to receive(:pr_title).and_return('Something')
      end

      describe 'has_app_changes?' do
        it 'returns true when single source has changed' do
          allow(@plugin.git).to receive(:modified_files).and_return(['src/a.txt'])

          expect(@plugin.has_app_changes?('src/')).to be(true)
        end

        it 'returns true when single nested source has changed' do
          allow(@plugin.git).to receive(:modified_files).and_return(['src/a/b/c.txt'])

          expect(@plugin.has_app_changes?('src/')).to be(true)
        end

        it 'returns true when single source has changed with multiple sources defined' do
          allow(@plugin.git).to receive(:modified_files).and_return(['common/src/c.txt'])

          expect(@plugin.has_app_changes?('common/src/', 'web/src')).to be(true)
        end

        it 'returns true when single nested source has changed with multiple sources defined' do
          allow(@plugin.git).to receive(:modified_files).and_return(['web/src/a/b/c.txt'])

          expect(@plugin.has_app_changes?('common/src/', 'web/src')).to be(true)
        end

        it 'returns true when multiple nested source has changed' do
          allow(@plugin.git).to receive(:modified_files).and_return(['c.txt', 'src/a/c.txt'])

          expect(@plugin.has_app_changes?('src')).to be(true)
        end

        it 'returns true when multiple nested source has changed with multiple sources' do
          allow(@plugin.git).to receive(:modified_files).and_return([
            'c.txt',
            'common/src/a/c.txt',
            'web/src/a/c.txt',
          ])

          expect(@plugin.has_app_changes?('common/src', 'web/src')).to be(true)
        end

        it 'returns false when source is in the middle of a modified file' do
          allow(@plugin.git).to receive(:modified_files).and_return([
            'a/src/c.txt',
            'a/src.txt',
          ])

          expect(@plugin.has_app_changes?('src')).to be(false)
        end

        it 'returns false when no source has changed' do
          allow(@plugin.git).to receive(:modified_files).and_return([
            'c.txt',
            'common/a/c.txt',
            'web/a/c.txt',
          ])

          expect(@plugin.has_app_changes?('src')).to be(false)
        end

        it 'returns false when no source has changed with multiple sources' do
          allow(@plugin.git).to receive(:modified_files).and_return([
            'c.txt',
            'common/a/c.txt',
            'web/a/c.txt',
          ])

          expect(@plugin.has_app_changes?('common/src', 'web/src')).to be(false)
        end

        it 'supports regexp source' do
          allow(@plugin.git).to receive(:modified_files).and_return(['ab/1.txt'])

          expect(@plugin.has_app_changes?(%r{[abc]+/[123]\.txt})).to be(true)
        end

        it 'uses plugin config sources when no arguments passed' do
          @plugin.config do
            sources %r{[abc]+/[123]\.txt}
          end

          allow(@plugin.git).to receive(:modified_files).and_return(['ab/1.txt'])

          expect(@plugin.has_app_changes?).to be(true)
        end
      end
    end
  end
end

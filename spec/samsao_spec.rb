require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    it 'should be a plugin' do
      expect(Danger::DangerSamsao.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'samsao_config' do
        it 'can configure single source' do
          @plugin.config do
            sources 'app/src'
          end

          expect(@plugin.config.sources).to eq(['app/src'])
        end

        it 'can configure multiple sources' do
          @plugin.config do
            sources 'app/src', 'lib/src'
          end

          expect(@plugin.config.sources).to eq(['app/src', 'lib/src'])
        end
      end

      describe 'branching model' do
        ['fix', 'feature', 'release', 'trivia'].each do |branch_prefix|
          it "continues on #{branch_prefix}/ prefix" do
            allow(@plugin.github).to receive(:branch_for_head).and_return("#{branch_prefix}/something")

            @plugin.fail_when_wrong_branching_model

            expect(@dangerfile).to have_no_error
          end
        end

        it 'fails on wrong prefix' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('wrong/12')

          @plugin.fail_when_wrong_branching_model

          expect(@dangerfile).to have_error('Your branch should be prefixed with feature/, fix/, trivia/ or release/!')
        end

        it 'fails on good prefix but wrong format' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature_12')

          @plugin.fail_when_wrong_branching_model

          expect(@dangerfile).to have_error('Your branch should be prefixed with feature/, fix/, trivia/ or release/!')
        end
      end

      describe 'feature branch commits' do
        it 'continues on feature branch and one commit' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.git).to receive(:commits).and_return(['sha1'])

          @plugin.fail_when_non_single_commit_feature

          expect(@dangerfile).to have_no_error
        end

        it 'continues on non-feature branch and multiple commits' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('fix/a')
          allow(@plugin.git).to receive(:commits).and_return(['sha1', 'sha2'])

          @plugin.fail_when_non_single_commit_feature

          expect(@dangerfile).to have_no_error
        end

        it 'fails on feature branch and multiple commits' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature/a')
          allow(@plugin.git).to receive(:commits).and_return(['sha1', 'sha2'])

          @plugin.fail_when_non_single_commit_feature

          expected_message = 'Your feature branch should have a single commit but found 2, squash them together!'
          expect(@dangerfile).to have_error(expected_message)
        end
      end
    end
  end
end

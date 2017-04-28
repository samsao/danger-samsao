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

          expect(@dangerfile).to have_error('Your branch should be prefixed with feature/, fix/ or release/!')
        end
      end
    end
  end
end

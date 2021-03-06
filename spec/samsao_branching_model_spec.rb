require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
        @wrong_branching_model = 'Your branch should be prefixed with feature/, fix/, ' \
                                 'bugfix/, hotfix/, release/ or support/!'
      end

      describe 'branching model' do
        ['fix', 'bugfix', 'hotfix', 'feature', 'release', 'support'].each do |branch_prefix|
          it "continues on #{branch_prefix}/ prefix" do
            allow(@plugin.github).to receive(:branch_for_head).and_return("#{branch_prefix}/something")

            @plugin.check_wrong_branching_model

            expect(@dangerfile).to have_no_error
          end
        end

        it 'fails on wrong prefix' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('wrong/12')

          @plugin.check_wrong_branching_model

          expect(@dangerfile).to have_error(@wrong_branching_model)
        end

        it 'fails on good prefix but wrong format' do
          allow(@plugin.github).to receive(:branch_for_head).and_return('feature_12')

          @plugin.check_wrong_branching_model

          expect(@dangerfile).to have_error(@wrong_branching_model)
        end
      end
    end
  end
end

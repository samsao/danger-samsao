require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'project_key?' do
        it "doesn't have project key" do
          expect(@plugin.project_key?).to eq(false)
        end

        it 'has project key' do
          project_key = 'VER'

          @plugin.config do
            project_key project_key
          end

          expect(@plugin.project_key?).to eq(true)
        end

        it 'has invalid project key' do
          project_key = '123'
          message = "Project key '#{project_key}' is invalid, must be uppercase and between 1 and 10 characters"

          expect { @plugin.config { project_key project_key } }.to raise_error(message)
          expect(@plugin.project_key?).to eq(false)
        end
      end
    end
  end
end

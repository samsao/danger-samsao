require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'config sources' do
        it 'defaults to empty array when not set' do
          expect(@plugin.config.sources).to eq([])
        end

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

      describe 'config changelogs' do
        it 'defaults to [CHANGELOG.md] array when not set' do
          expect(@plugin.config.changelogs).to eq(['CHANGELOG.md'])
        end

        it 'can configure single changelog' do
          @plugin.config do
            changelogs 'a'
          end

          expect(@plugin.config.changelogs).to eq(['a'])
        end

        it 'can configure multiple changelogs' do
          @plugin.config do
            changelogs 'a', 'b'
          end

          expect(@plugin.config.changelogs).to eq(['a', 'b'])
        end
      end

      describe 'config project_type' do
        it 'defaults to :application when not set' do
          expect(@plugin.config.project_type).to eq(:application)
        end

        [:application, :library].each do |type|
          it "accepts :#{type} type" do
            @plugin.config do
              project_type type
            end

            expect(@plugin.config.project_type).to eq(type)
          end
        end

        it 'rejects invalid types when wrong type is a symbol' do
          message = "Project type ':custom' is invalid, must be one of ':application, :library'"

          expect { @plugin.config { project_type :custom } }.to raise_error(message)
        end

        it 'rejects invalid types when wrong type is a string' do
          message = "Project type 'custom' is invalid, must be one of ':application, :library'"

          expect { @plugin.config { project_type 'custom' } }.to raise_error(message)
        end
      end

      describe 'config project_key' do
        it 'accepts project key' do
          project_key = 'VER'

          @plugin.config do
            project_key project_key
          end

          expect(@plugin.config.project_key).to eq(project_key)
        end

        it 'reject invalid project key containing numbers' do
          project_key = '123'
          message = "Project key '#{project_key}' is invalid, must be uppercase and between 1 and 10 characters"

          expect { @plugin.config { project_key project_key } }.to raise_error(message)
        end

        it 'reject invalid project key containing lowercase characters' do
          project_key = 'invalid'
          message = "Project key '#{project_key}' is invalid, must be uppercase and between 1 and 10 characters"

          expect { @plugin.config { project_key project_key } }.to raise_error(message)
        end
      end
    end
  end
end

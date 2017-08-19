require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
        @content = 'Message'
      end

      describe 'report' do
        it 'send fail' do
          @plugin.report(:fail, @content)
          expect(@dangerfile).to have_error(@content)
          expect(@dangerfile).to have_no_warning
          expect(@dangerfile).to have_no_message
        end

        it 'send warn' do
          @plugin.report(:warn, @content)
          expect(@dangerfile).to have_warning(@content)
          expect(@dangerfile).to have_no_error
          expect(@dangerfile).to have_no_message
        end

        it 'send message' do
          @plugin.report(:message, @content)
          expect(@dangerfile).to have_message(@content)
          expect(@dangerfile).to have_no_warning
          expect(@dangerfile).to have_no_error
        end

        it 'send unknown level' do
          level = 'unknown'
          error = "Report level '#{level}' is invalid."
          expect { @plugin.report(level, @content) }.to raise_error(error)
          expect(@dangerfile).to have_no_warning
          expect(@dangerfile).to have_no_error
          expect(@dangerfile).to have_no_message
        end
      end
    end
  end
end

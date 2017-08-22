require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'shorten sha helper' do
        it 'shorten short string' do
          expect(@plugin.shorten_sha('1234')).to eq('1234')
        end

        it 'shorten long string' do
          expect(@plugin.shorten_sha('1234567890')).to eq('12345678')
        end

        it 'shorten nil string' do
          expect(@plugin.shorten_sha(nil)).to eq(nil)
        end
      end
    end
  end
end

require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerSamsao do
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.samsao
      end

      describe 'truncate helper' do
        it 'truncate short string' do
          expect(@plugin.truncate('1234')).to eq('1234')
        end

        it 'truncate long string' do
          actual = 'abcdefghijklmnopqrstuvwxyz1234567890'
          expected = 'abcdefghijklmnopqrstuvwxyz1234'

          expect(@plugin.truncate(actual)).to eq(expected)
        end

        it 'truncate nil string' do
          expect(@plugin.truncate(nil)).to eq(nil)
        end

        it 'truncate custom length string' do
          actual = 'abcdefghijklmnopqrstuvwxyz1234567890'
          expected = 'abcde'

          expect(@plugin.truncate(actual, 5)).to eq(expected)
        end
      end
    end
  end
end

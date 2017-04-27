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

      it 'Warns on a monday' do
        monday_date = Date.parse('2016-07-11')
        allow(Date).to receive(:today).and_return monday_date

        @plugin.warn_on_mondays

        expect(@dangerfile.status_report[:warnings]).to eq(['Trying to merge code on a Monday'])
      end

      it 'Does nothing on a tuesday' do
        monday_date = Date.parse('2016-07-12')
        allow(Date).to receive(:today).and_return monday_date

        @plugin.warn_on_mondays

        expect(@dangerfile.status_report[:warnings]).to eq([])
      end
    end
  end
end

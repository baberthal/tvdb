require 'spec_helper'

RSpec.describe TVDB::Client, :dummy_tvdb do
  let(:client) { described_class.new }

  describe 'retrieving info' do
    describe '#search_series' do
      it 'returns an array of series' do
        expect(client.search_series('Archer')).to be_an Array
      end

      it 'returns the proper results' do
        expect(client.search_series('Archer').length).to eq 3
      end
    end

    describe '#series_base_info' do
      it 'returns base info for the series' do
        response = client.series_base_info(110_381)[:en]['Data']['Series']
        expect(response['Network']).to eq 'FXX'
      end
    end
  end
end

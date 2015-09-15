require 'spec_helper'

RSpec.describe TVDB do
  it 'has a version number' do
    expect(TVDB::VERSION).not_to be nil
  end

  describe 'singleton methods' do
    before :each do
      described_class.options[:api_key] = ENV['TVDB_KEY']
    end

    it 'knows the api key' do
      expect(described_class.api_key).to_not be_nil
      expect(described_class.api_key).to eq ENV['TVDB_KEY']
    end

    describe '#api_key=' do
      before do
        described_class.api_key = '1234567890'
      end

      it 'sets the api_key' do
        expect(described_class.api_key).to eq '1234567890'
      end
    end

    describe '#languages' do
      it 'returns an array of language hashes' do
        expect(described_class.languages).to be_an Array
      end
    end

    describe '#typemasks' do
      it 'returns a hash' do
        expect(described_class.typemasks).to be_a Hash
      end

      it 'returns the typemasks included in an xml_mirror' do
        expect(described_class.typemasks[:xml]).to include '1'
        expect(described_class.typemasks[:xml]).to include '3'
        expect(described_class.typemasks[:xml]).to include '5'
        expect(described_class.typemasks[:xml]).to include '7'
      end

      it 'returns the typemasks included in a banner_mirror' do
        expect(described_class.typemasks[:banner]).to include '2'
        expect(described_class.typemasks[:banner]).to include '3'
        expect(described_class.typemasks[:banner]).to include '6'
        expect(described_class.typemasks[:banner]).to include '7'
      end

      it 'returns the typemasks included in a zip_mirror' do
        expect(described_class.typemasks[:zip]).to include '4'
        expect(described_class.typemasks[:zip]).to include '6'
        expect(described_class.typemasks[:zip]).to include '7'
      end
    end

    describe '#mirror_list' do
      it 'returns a mirror_list object' do
        expect(described_class.mirror_list).to be_a TVDB::MirrorList
      end
    end

    describe '#xml_mirror' do
      context 'without options' do
        it 'returns a properly formatted mirror' do
          expect(described_class.xml_mirror).to match(%r{thetvdb\.com/api})
        end
      end

      context 'with options' do
        describe 'with key: true' do
          it 'returns a properly formatted mirror' do
            expect(described_class.xml_mirror(key: true))
              .to include ENV['TVDB_KEY']
          end
        end

        describe 'with key: false' do
          it 'returns a properly formatted mirror' do
            expect(described_class.xml_mirror(key: false))
              .to_not include ENV['TVDB_KEY']
          end
        end
      end
    end

    describe '#banner_mirror' do
      it 'returns a properly formatted morror' do
        expect(described_class.banner_mirror).to match(%r{thetvdb\.com/banners})
      end
    end

    describe '#zip_mirror' do
      it 'returns a properly formatted morror' do
        expect(described_class.zip_mirror).to match(%r{thetvdb\.com/api})
      end
    end

    describe '#previous_time' do
      it 'returns a timestamp' do
        expect(described_class.previous_time).to match(/[0-9]{10}/)
      end
    end

    describe '#options' do
      it 'returns an Options object with the TVDB api_key' do
        expect(described_class.options).to be_a TVDB::Options
        expect(described_class.options[:api_key]).to eq ENV['TVDB_KEY']
      end
    end

    describe '#options=' do
      before :each do
        described_class.options = { api_key: '1234567890' }
      end

      it 'returns a new Options object with the passed options' do
        expect(described_class.options[:api_key]).to eq '1234567890'
      end
    end
  end
end

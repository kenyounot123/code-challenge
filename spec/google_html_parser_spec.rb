require_relative '../lib/google_html_parser'
require 'json'

RSpec.describe GoogleHtmlParser do
  let(:html_file) { 'files/van-gogh-paintings.html' }
  let(:parser) { described_class.new(html_file) }

  describe '#initialize' do
    it 'creates a new parser instance with dependencies' do
      expect(parser.parsed_document).to be_a(Nokogiri::HTML::Document)
      expect(parser.image_map).to be_a(Hash)
      expect(parser.carousel_item_parser).to be_a(CarouselItemParser)
    end
  end

  describe '#execute' do
    it 'returns a hash with artworks array' do
      result = parser.execute
      expect(result).to be_a(Hash)
      expect(result).to have_key(:artworks)
      expect(result[:artworks]).to be_an(Array)
    end
  end

  describe '#fetch_carousel_items' do
    it 'returns a node set of carousel items' do
      items = parser.send(:fetch_carousel_items)
      expect(items).to be_a(Nokogiri::XML::NodeSet)
      expect(items.css('a.klitem')).not_to be_empty
    end
  end

  context 'with Van-Gogh-Paintings html file' do
    let(:expected_data) { JSON.parse(File.read('files/expected-array.json')) }

    it 'extracts expected number of artworks' do
      result = parser.execute
      expect(result[:artworks].length).to eq(expected_data['artworks'].length)
    end

    it 'matches expected artwork data' do
      result = parser.execute
      artworks = result[:artworks]

      expected_data['artworks'].each_with_index do |expected_artwork, index|
        actual_artwork = artworks[index]

        expect(actual_artwork[:name]).to eq(expected_artwork['name'])
        expect(actual_artwork[:link]).to eq(expected_artwork['link'])
        expect(actual_artwork[:extensions]).to eq(expected_artwork['extensions'])
        expect(actual_artwork[:image]).to eq(expected_artwork['image'])
      end
    end
  end

end

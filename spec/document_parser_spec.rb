require_relative '../lib/document_parser'

RSpec.describe DocumentParser do
  let(:html_file) { 'files/van-gogh-paintings.html' }
  let(:parser) { described_class.new(html_file) }

  describe '#initialize' do
    it 'parses the html file' do
      expect(parser.parsed_document).to be_a(Nokogiri::HTML::Document)
    end

    it 'sets the html_file' do
      expect(parser.html_file).to eq(html_file)
    end
  end

  describe '#demo?' do
    context 'when file is van-gogh-paintings.html' do
      it 'returns true' do
        expect(parser.demo?).to be true
      end
    end

    context 'when file is not van-gogh-paintings.html' do
      let(:html_file) { 'files/da-vinci-artworks.html' }
      
      it 'returns false' do
        expect(parser.demo?).to be false
      end
    end
  end
end

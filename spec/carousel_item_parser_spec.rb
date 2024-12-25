require_relative '../lib/carousel_item_parser'

RSpec.describe CarouselItemParser do
  let(:base_url) { 'https://example.com' }
  let(:image_map) { { 'image-1' => 'https://example.com/image1.jpg' } }
  let(:html_file) { 'files/van-gogh-paintings.html' }
  let(:parser) { described_class.new(base_url, image_map, html_file) }

  describe '#initialize' do
    it 'sets up parser with correct attributes' do
      expect(parser.base_url).to eq(base_url)
      expect(parser.image_map).to eq(image_map)
      expect(parser.html_file).to eq(html_file)
      expect(parser.parsed_document).to be_a(Nokogiri::HTML::Document)
    end
  end

  describe '#parse' do
    let(:item) do
      doc = Nokogiri::HTML4::DocumentFragment.parse(<<-HTML
        <a href="/test/123" aria-label="Test Name">
          <img id="image-1" src="placeholder.jpg">
          <div class="ellip klmeta">Extension 1</div>
          <div class="ellip klmeta">Extension 2</div>
        </a>
      HTML
      )
      doc.at_css('a')
    end

    it 'parses a carousel item correctly' do
      result = parser.parse(item)

      expect(result).to eq({
        name: 'Test Name',
        link: 'https://example.com/test/123',
        image: 'https://example.com/image1.jpg',
        extensions: ['Extension 1', 'Extension 2']
      })
    end

    context 'when item has no extensions' do
      let(:item) do
        doc = Nokogiri::HTML4::DocumentFragment.parse(<<-HTML
          <a href="/test/123" aria-label="Test Name">
            <img id="image-1" src="placeholder.jpg">
          </a>
        HTML
        )
        doc.at_css('a')
      end

      it 'returns item without extensions key' do
        result = parser.parse(item)

        expect(result).to eq({
          name: 'Test Name',
          link: 'https://example.com/test/123',
          image: 'https://example.com/image1.jpg'
        })
      end
    end
  end

  describe 'private methods' do
    let(:item) do
      doc = Nokogiri::HTML4::DocumentFragment.parse(<<-HTML
        <a href="/test/123" aria-label="Test Name">
          <img id="image-1" src="placeholder.jpg">
          <div class="ellip klmeta">
            <span>Extension 1</span>
          </div>
        </a>
      HTML
      )
      doc.at_css('a')
    end

    describe '#name' do
      context 'when in demo mode' do
        it 'returns the aria-label attribute' do
          expect(parser.send(:name, item)).to eq('Test Name')
        end
      end

      context 'when not in demo mode' do
        let(:html_file) { 'files/da-vinci-artworks.html' }
        
        it 'returns the first div text' do
          allow(item).to receive_message_chain(:css, :children, :first, :text).and_return('Test Name')
          expect(parser.send(:name, item)).to eq('Test Name')
        end
      end
    end

    describe '#link' do
      context 'when in demo mode' do
        it 'combines base_url with href' do
          expect(parser.send(:link, item)).to eq('https://example.com/test/123')
        end
      end

      context 'when not in demo mode' do
        let(:html_file) { 'files/da-vinci-artworks.html' }
        
        it 'combines base_url with a href' do
          allow(item).to receive_message_chain(:at_css).with('a').and_return({'href' => '/test/123'})
          expect(parser.send(:link, item)).to eq('https://example.com/test/123')
        end
      end
    end

    describe '#image' do
      it 'returns the mapped image URL' do
        expect(parser.send(:image, item)).to eq('https://example.com/image1.jpg')
      end
    end

    describe '#extensions' do
      context 'when in demo mode' do
        it 'returns array of extension texts' do
          expect(parser.send(:extensions, item)).to eq(['Extension 1'])
        end
      end

      context 'when not in demo mode' do
        let(:html_file) { 'files/da-vinci-artworks.html' }
        
        it 'returns array of div texts' do
          mock_div = double('div', text: 'Extension 1')
          allow(item).to receive(:css).with('div>div+div').and_return([mock_div])
          expect(parser.send(:extensions, item)).to eq(['Extension 1'])
        end
      end
    end
  end
end
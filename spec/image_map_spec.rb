require_relative '../lib/image_map'

RSpec.describe ImageMap do
  let(:html_file) { 'files/van-gogh-paintings.html' }
  let(:image_map) { described_class.new(html_file) }

  describe '#to_h' do
    context 'when in demo mode' do
      it 'extracts image mappings from script content' do
        expected_result = {
          'image_1' => 'path/to/image.jpg',
          'image_2' => 'another/image.png'
        }

        allow(image_map).to receive(:script_content).and_return(<<-SCRIPT
          _setImagesSrc();
          var s = 'path/to/image.jpg'; var ii = ['image_1'];
          var s = 'another/image.png'; var ii = ['image_2'];
        SCRIPT
        )
        
        expect(image_map.to_h).to eq(expected_result)
      end
    end

    context 'when not in demo mode' do
      let(:html_file) { 'files/da-vinci-artworks.html' }

      it 'extracts image mappings with different format' do
        expected_result = {
          'image_1' => 'path/to/image.jpg',
          'image_2' => 'another/image.png'
        }

        allow(image_map).to receive(:script_content).and_return(<<-SCRIPT
          _setImagesSrc();
          var s='path/to/image.jpg';var ii=['image_1'];
          var s='another/image.png';var ii=['image_2'];
        SCRIPT
        )
        
        expect(image_map.to_h).to eq(expected_result)
      end
    end
  end

  describe '#script_content' do
    it 'finds scripts containing _setImagesSrc' do
      allow(image_map.parsed_document).to receive(:css).with('script').and_return([
        double(text: 'some other script'),
        double(text: '_setImagesSrc(); var s="test";'),
        double(text: 'another script')
      ])

      expect(image_map.send(:script_content)).to include('_setImagesSrc')
    end
  end
end
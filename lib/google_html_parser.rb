require_relative 'image_map'
require_relative 'document_parser'
require_relative 'carousel_item_parser'

class GoogleHtmlParser < DocumentParser
  BASE_URL = "https://www.google.com".freeze

  attr_reader :image_map, :carousel_item_parser, :carousel_items

  def initialize(html_file)
    super
    @image_map = ImageMap.new(html_file).to_h
    @carousel_item_parser = CarouselItemParser.new(BASE_URL, image_map, html_file)
    @carousel_items = fetch_carousel_items
  end

  def execute
    { artworks: carousel_items.map { |item| carousel_item_parser.parse(item) } }
  end

  private

  def fetch_carousel_items
    if demo?
      parsed_document
        .css('g-scrolling-carousel')
        .css('a.klitem')
    else
      parsed_document
        .at_css('g-loading-icon')
        .parent
        .children[1]
        .children
    end
  end
end

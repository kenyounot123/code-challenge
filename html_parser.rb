require 'nokogiri'
require_relative 'image_map'

class HtmlParser
  BASE_URL = "https://www.google.com".freeze

  attr_reader :parsed_document
  attr_reader :carousel_items
  attr_reader :image_map

  def initialize(html_file)
    @parsed_document = File.open(html_file) { |f| Nokogiri::HTML(f) }
    @image_map = ImageMap.new(parsed_document).to_h
  end

  def execute
    fetch_carousel_items
    result = { artworks: [] }
    result[:artworks] = carousel_items.map { |item| parse_carousel_item(item) }
    puts result
  end

  private

  def fetch_carousel_items
    @carousel_items = parsed_document
      .xpath("//g-scrolling-carousel")
      .css('a.klitem')
  end

  def parse_carousel_item(carousel_item)
    {
      name: name(carousel_item),
      extensions: extensions(carousel_item),
      link: link(carousel_item),
      image: src(carousel_item)
    }
  end

  def name(carousel_item)
    carousel_item['title'].split(" ")[0...-1].join(" ")
  end

  def extensions(carousel_item)
    carousel_item.css('div.ellip.klmeta')&.children.map(&:text)
  end

  def link(carousel_item)
    BASE_URL + carousel_item['href']
  end

  def src(carousel_item)
    image_map[carousel_item.at_css('img')['id']]
  end

end

require 'cgi'
require_relative 'document_parser'

class CarouselItemParser < DocumentParser
  attr_reader :base_url, :image_map, :html_file

  def initialize(base_url, image_map, html_file)
    super(html_file)
    @base_url = base_url
    @image_map = image_map
  end

  def parse(item)
    carousel_item = {
      name: name(item),
      link: link(item),
      image: image(item)
    }

    carousel_item[:extensions] = extensions(item) unless extensions(item).empty?
    carousel_item
  end

  private

  def name(item)
    if demo?
      item['aria-label']
    else
      item.css('div').children.first.text
    end
  end

  def extensions(item)
    if demo?
      item.css('div.ellip.klmeta')&.children&.map(&:text)&.map(&:strip)&.reject(&:empty?)
    else
      item.css('div>div+div').map(&:text).map(&:strip).reject(&:empty?)
    end
  end

  def link(item)
    if demo?
      @base_url + item['href']
    else
      @base_url + item.at_css('a')['href']
    end
  end

  def image(item)
    @image_map[item.at_css('img')['id']]
  end
end

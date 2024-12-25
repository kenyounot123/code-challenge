require_relative 'lib/google_html_parser'
require 'json'

class Scraper
  def initialize
    @van_gogh_parser = GoogleHtmlParser.new('files/van-gogh-paintings.html')
    @da_vinci_parser = GoogleHtmlParser.new('files/da-vinci-artworks.html')
    @pablo_picasso_parser = GoogleHtmlParser.new('files/pablo-picasso-artworks.html')
  end

  def save_to_files
    File.write('scraped-van-gogh-paintings.json', JSON.pretty_generate(@van_gogh_parser.execute))
    File.write('scraped-da-vinci-paintings.json', JSON.pretty_generate(@da_vinci_parser.execute))
    File.write('scraped-picasso-paintings.json', JSON.pretty_generate(@pablo_picasso_parser.execute))
  end
end

scraper = Scraper.new
scraper.save_to_files

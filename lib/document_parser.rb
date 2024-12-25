require 'nokogiri'

class DocumentParser
  attr_reader :parsed_document, :html_file

  def initialize(html_file)
    @html_file = html_file
    @parsed_document = parse_file(html_file)
  end

  def demo?
    html_file == 'files/van-gogh-paintings.html'
  end

  private

  def parse_file(html_file)
    File.open(html_file) { |f| Nokogiri::HTML(f, nil, 'UTF-8') }
  end
end

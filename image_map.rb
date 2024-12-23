require 'nokogiri'
class ImageMap
  attr_reader :parsed_document

  def initialize(parsed_document)
    @parsed_document = parsed_document
  end

  def to_h
    script_content
      .scan(/var s = '(.*?)'; var ii = \['(.*?)'\]/)
      .map { |src, id| [id, src.gsub('\\', '')] }
      .to_h
  end

  def script_content
    parsed_document.css('script').select { |script| script.text.include?('_setImagesSrc') }.map(&:text).join
  end

end

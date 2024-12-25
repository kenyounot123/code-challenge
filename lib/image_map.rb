require_relative 'document_parser'

class ImageMap < DocumentParser
  def initialize(html_file)
    super
  end

  def to_h
    if demo?
      script_content
        .scan(/var s = '(.*?)'; var ii = \['(.*?)'\]/)
        .map { |src, id| [id, src.gsub('\\', '')] }
        .to_h
    else
      script_content
        .scan(/var s='(.*?)';var ii=\['(.*?)'\]/)
        .map { |src, id| [id, src.gsub('\\', '')] }
        .to_h
    end
  end

  private 

  def script_content
    parsed_document.css('script').select { |script| script.text.include?('_setImagesSrc') }.map(&:text).join
  end
end

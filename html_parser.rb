# Given a html file we want to parse the html file and extract data returning it in a json/yml format with the fields:
# { 
#   "paintings": [
#     {
#       "name": string
#       "extensions": date[]
#       "link": string[] 
#     }
#   ],
#   painting_thunbnails : []
# }
# html_file = File.open("files/van-gogh-paintings.html") { |f| Nokogiri::HTML(f) }

# images = html_file.xpath("//img")

# puts images

require 'nokogiri'

class HtmlParser
  attr_accessor :parsed_document
  attr_reader :carousel_images

  private 

  def initialize(html_file)
    @parsed_document = File.open(html_file) { |f| Nokogiri::HTML(f) }
  end

  def carousel_images
    # Returns the images in the carousel in an array
    parsed_document.xpath("//g-scrolling-carousel")[0]
  end

  def carousel_image_names
    # Returns the names of the images in the carousel in an array of strings
  end

  def carousel_image_extensions
    # Returns the extensions of the images in the carousel in an array of dates
  end

  def carousel_image_links
    # Returns the links of the images in the carousel in an array of string urls
  end

  public

  def execute
    # Returns the json/yml formatted data
    data = {
      items: []
    }

    carousel_images.each do |image|

    end

    data.to_json
  end

end
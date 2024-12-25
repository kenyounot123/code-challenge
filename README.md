# SerpApi Code Challenge

This is a solution to the SerpApi Code Challenge.
Creates a class `GoogleHtmlParser` that can be used to scrape Google search results pages and then saves the results to a JSON file.

- `scraper.rb` is the file that executes the scraper.
- `document_parser.rb` is the parent class to handle the demo mode logic and the parsing of the HTML file.
- `google_html_parser.rb` is the class that encapsulates the logic to parse the Google search results page.
- `carousel_item_parser.rb` is the class that parses the carousel items and extracts the name, link, image, and extensions.
- `image_map.rb` is the class that creates the hash mapping image id to image url from the HTML file.

To run tests:
```
bundle install
bundle exec rspec
```

To run the scraper:
```
bundle install
ruby scraper.rb
```

The demo mode is set to true if the file being scraped is `van-gogh-paintings.html`. which is the test file provided in the challenge.
I found searched up two other similar result pages to test the scraper against. The demo mode is needed to differentiate between the test file and the other two because they have different layouts.

# Challenges

1. Different layouts for the carousel items on certain search results pages.
2. Getting used to the Nokogiri gem and its methods.
3. Refactoring the code to be more readable and maintainable.
4. Took a little longer than expected to get the hang of the gem and the methods.
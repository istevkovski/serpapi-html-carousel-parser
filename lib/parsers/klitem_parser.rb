require 'json'
require 'base64'
require 'open-uri'
require_relative '../carousel_parser'

GOOGLE_DOMAIN = 'https://www.google.com'

class KlitemParser < CarouselParser
  def parse
    doc = Nokogiri::HTML(@html)

    collection = { artworks: [] }

    carousel = get_carousel(doc)
    items = get_items(carousel)

    collection[:artworks] = create_collection(items)

    # Return an array containing the extracted data
    JSON.pretty_generate(collection)
  end

  # Checks if the parser is suitable to the html file
  # Criteria: carousel and items must exist
  def is_suitable
    doc = Nokogiri::HTML(@html)
    carousel = get_carousel(doc)
    items = get_items(carousel)

    items.length and items[0]&.children&.length == 2
  end

  private

  def create_collection(items)
    super
  end

  def get_carousel(doc)
    return nil unless doc.respond_to?(:css)

    doc&.css('g-scrolling-carousel')
  end

  def get_items(carousel)
    # Select every a-tag containing the substring klitem
    carousel&.css('a[class*=klitem]') || []
  end

  def get_item_name(item)
    item&.css('*:nth-child(2)')&.children&.[](0)&.text&.strip
  end

  def get_extensions(item)
    extensions = []
    found_extensions = item.css('*:nth-child(2) > *:nth-child(2)').text.strip

    return nil if found_extensions.length < 1

    extensions << found_extensions
    extensions
  end

  def get_link(item)
    item['href'] ? "#{GOOGLE_DOMAIN}#{item['href']}" : nil
  end

  def get_thumbnail(item)
    thumbnail_link = item&.css('img')&.[](0)&.[]('data-key')
    return nil unless thumbnail_link

    thumbnail = URI.open(thumbnail_link, 'rb') { |f| f.read }
    encoded_image = Base64.strict_encode64(thumbnail)

    "data:image/jpeg;base64,#{encoded_image}"
  end
end

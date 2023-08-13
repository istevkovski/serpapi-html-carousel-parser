require 'nokogiri'

class CarouselParser
	def initialize(html)
		@html = html
	end

	# Parser purpose:
	# Extract item name, extensions array (data), Google Link and thumbnails
	def parse
		doc = Nokogiri::HTML(@html)

		collection = {
			artworks: []
		}

		# Select the carousel items
		items = doc.css('.klitem')

		items.each do |item|
			item_name = item.css('*:nth-child(2) > *:nth-child(1)').text.strip
			item_extensions = item.css('*:nth-child(2) > *:nth-child(2)').text.strip
			item_link = "https://google.com#{item["href"]}"
			item_image = item.css("img")[0]["data-key"]

			collection[:artworks] << {
				name: item_name,
				extensions: [item_extensions],
				link: item_link,
				image: item_image
			}
		end

		puts collection[:artworks][0]

		# Return an array containing the extracted data
		collection
	end
end
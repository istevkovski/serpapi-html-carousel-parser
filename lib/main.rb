require_relative './parsers/klitem_parser'
require_relative 'carousel_parser'

class Main
  def initialize(html)
    @html = html
  end

  def parse
    parser = KlitemParser.new(@html)
    result = parser.parse

    # File.write(File.join(__dir__, '../files/export.json'), result)
  end

  def parse_automated
    collection = []
    parsers = [KlitemParser]

    parsers.each do |current_parser|
      parser = current_parser.new(@html)
      collection = parser.parse if parser.is_suitable

      puts collection
    end
  end
end

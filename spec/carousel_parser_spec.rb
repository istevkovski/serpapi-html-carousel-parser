require 'spec_helper'
require 'json'
require_relative '../lib/main'

describe 'CarouselParser' do
  BASE64_PATTERN = %r{\Adata:image/\w+;base64,[A-Za-z0-9+/]+=*\z}

  describe 'Van Gogh Paintings' do
    before :all do
      @html = File.read(File.join(__dir__, '../files/van-gogh-paintings.html'))
      @parser = Main.new(@html)
      @parsed = @parser.parse_automated
      @expected = File.read(File.join(__dir__, './expected-van-gogh-paintings.json'))
    end

    it 'Returns valid parsed data' do
      json = JSON.pretty_generate(@parsed)
      expect(json).to eq(@expected)
      expect(@parsed).not_to be_empty
    end

    it 'name' do
      expect(@parsed[:artworks][0][:name]).to be_a(String)
      expect(@parsed[:artworks][0][:name]).to_not be_empty
    end

    it 'link' do
      expect(@parsed[:artworks][0][:link]).to be_a(String)
      expect(@parsed[:artworks][0][:link]).to_not be_empty
    end

    it 'image' do
      expect(@parsed[:artworks][0][:image]).to be_a(String)
      expect(@parsed[:artworks][0][:image]).to match(BASE64_PATTERN)
      expect(@parsed[:artworks][0][:image]).to_not be_empty
    end

    it 'extensions' do
      expect(@parsed[:artworks][0][:extensions]).to be_a(Array)
      expect(@parsed[:artworks][0][:extensions]).to_not be_empty
    end
  end
end

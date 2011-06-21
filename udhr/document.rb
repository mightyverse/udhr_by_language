require 'nokogiri'
require './article'

module UDHR
  class Document
    attr_reader :articles, :html

    def initialize(filename)
      File.open(filename, "r:UTF-8") do |f|
        @xml = Nokogiri::XML(f)
        @articles = []
        nodes = @xml.css('article')
        article1 = false
        nodes.each do |node| 
          title = node.css('title').text
          #title = UDHR::Document.clean_text(title)
          text = node.css('para').map(&:text)
          
          @articles << Article.new(title, text)
        end
      end
    end

    def phrases
      result = []
      @articles.each do |article|
        result += article.phrases
      end
      result
    end

    def self.clean_text(t)
      t.gsub!(/^\s*\(?\s*\d*\.?\s*\)?\s*/, "")  # remove leading numbers and whitespace
      t.gsub!(/\s*$/, "")   # remove trailing whitespace
      t.gsub(/\s+/, " ")    # remove double spaces
    end
  end
end

require 'nokogiri'
require './article'

module UDHR
  class Document
    attr_reader :articles, :html

    def initialize(filename)
      open(filename) do |f|
        @html = Nokogiri::HTML(f)
        @articles = []
        nodes = @html.css('#TEST div span')
        article1 = false
        nodes.children.each do |child| 
          # for now skip everything before the first Article
          article1 = true if child.name == 'h4' && child.inner_text.include?("1")
          next unless article1

          if child.name == 'h4' 
            @articles << Article.new(UDHR::Document.clean_text(child.inner_text))
          else 
            article = @articles.last
            data = []
            if child.name == 'p'
              data += child.xpath('text()') 
              article.text = article.text + data.map { |node| UDHR::Document.clean_text(node.inner_text) }
            end
            if child.name == 'ul' || child.name == 'ol'
              data += child.css('li') 
              article.sections = data.map { |node| UDHR::Document.clean_text(node.inner_text) }
            end
            
          end
          
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

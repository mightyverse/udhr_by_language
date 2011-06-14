require 'nokogiri'

module UDHR
  class Document
    attr_reader :phrases, :html
    def initialize(filename)
      open(filename) do |f|
        @html = Nokogiri::HTML(f)
        data = []
        nodes = @html.css('#TEST div span')
        article1 = false
        nodes.children.each do |child| 
          # for now skip everything before the first Article
          article1 = true if child.name == 'h4' && child.inner_text.include?("1")
          next unless article1

          data << child if child.name == 'h4'
          if child.name == 'p'
            data += child.xpath('text()')
          end
          data += child.css('li') if child.name == 'ul' || child.name == 'ol'     
        end
        @phrases = data.map { |node| UDHR::Document.clean_text(node.inner_text) }
      end
    end

    def self.clean_text(t)
      t.gsub!(/^\s*\(?\s*\d*\.?\s*\)?\s*/, "")  # remove leading numbers and whitespace
      t.gsub!(/\s*$/, "")   # remove trailing whitespace
      t.gsub(/\s+/, " ")    # remove double spaces
    end
  end
end

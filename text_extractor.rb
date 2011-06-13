require 'nokogiri'

module UDHR
  class Document
    attr_reader :phrases, :html
    def initialize(filename)
      open(filename) do |f|
        @html = Nokogiri::HTML(f)
        data = []
        nodes = @html.css('#TEST div span')
        nodes.children.each do |child| 
          data << child if child.name == 'h4'
          data += child.css('li') if child.name == 'ul' || child.name == 'ol'     
        end
        @phrases = data.map { |node| UDHR::Document.clean_text(node.inner_text) }
      end
    end

    def self.clean_text(t)
      t.gsub!(/^\s*\(?\s*\d*\s*\)?\s*/, "")
      t.gsub!(/\s*$/, "")
      t.gsub!(/\s+/, " ")      
    end
  end
end

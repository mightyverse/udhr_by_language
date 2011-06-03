require 'open-uri'
require 'nokogiri'

class DocumentFetcher

  def self.fetch(url)
    doc = Nokogiri::HTML(open(url))
    doc.css('span.udhrtext')
  end

end
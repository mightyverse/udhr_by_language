require 'nokogiri'
require 'open-uri'

module UDHR
  def self.index
    lang_info = []
    index_filename = File.join(File.dirname(__FILE__), "udhr_xml", "index.xml")
    File.open(index_filename)  do |f|
      docs = Nokogiri::XML(f).css('udhr')
      docs = docs.find_all { |doc| doc['iso639-3'] != '' and doc['stage'] >= '4' }      
      lang_info = docs.map do |doc| 
        { :name => doc['n'], :code => doc['iso639-3'] } 
      end
    end
    lang_info.uniq! { |i| i[:code] }
    lang_info
  end
end

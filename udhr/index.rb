require 'nokogiri'
require 'open-uri'

module UDHR
  def self.lang_info
    lang_info = []
    index_filename = File.join(File.dirname(__FILE__), "udhr_xml", "index.xml")
    puts index_filename
    open(index_filename) do |f|
      docs = Nokogiri::XML(f).css('udhr')
      docs = docs.find_all { |doc| doc['stage'] == '4' }
      lang_info = docs.map do |doc| 
        { :name => doc['n'], :iso639_3 => doc['iso639-3'] } 
      end
    end
    lang_info.find_all { |info| info[:iso639_3] != "" }
  end
end

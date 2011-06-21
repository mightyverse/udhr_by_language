


require 'nokogiri'
require 'open-uri'

  lang_info = []
  open('./udhr/udhr_xml/index.xml') do |f|
    docs = Nokogiri::XML('udhr_xml/index.xml')
    docs = docs.find_all { |doc| doc['stage'] == '4' }
    lang_info = docs.map { |doc| { :name => doc['n'], :iso639_3 => doc['iso639-3'] } }
    lang_info.uniq!
  end

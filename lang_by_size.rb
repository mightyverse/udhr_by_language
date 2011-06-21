# see fair use guidelines: http://www.ethnologue.com/FairUseGuidelines.pdf
# Up to 10% or 2500 fields or cell entries, whichever is less
# 350 / 6700 is 5.2%

require 'nokogiri'
require 'open-uri'

lang_info = []
open('./udhr_xml/index.xml') do |f|
  docs = Nokogiri::XML('udhr_xml/index.xml')
  docs = docs.find_all { |doc| doc['stage'] == '4' }
  lang_info = docs.map { |doc| { :name => doc['n'], :iso639_3 => doc['iso639-3'] } }
  lang_info.uniq!
end

lang_info.each do |info|
  c[:size] = Ethnologue::LanguageInfo.new(c[:iso639_3]).total_population
end

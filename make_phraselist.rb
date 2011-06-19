require './document'

lang1_code = ARGV[0]
lang2_code = ARGV[1]
lang2_code ||= "eng"
puts "#{lang1_code} #{lang2_code}"

lang1 = UDHR::Document.new("./udhr_xml/udhr_#{lang1_code}.xml")
lang2 = UDHR::Document.new("./udhr_xml/udhr_#{lang2_code}.xml")

File.open("#{lang1_code}-#{lang2_code}.txt", 'w:UTF-8') do |f|
  f.puts "Source Text	Translated Text	Media UUID	Phonetic Text	Video File Name	Phrase UUID	Language Code"
  lang2_phrases = lang2.phrases
  lang1.phrases.each_with_index do |lang1_phrase, index|
    #f.puts "#{lang1_phrase}\t#{lang2_phrases[index]}"
    f.puts "#{lang1_phrase}"
  end
end


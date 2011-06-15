require './document'

eng = UDHR::Document.new('./fixtures/ohchr-eng.html')
sso = UDHR::Document.new('./fixtures/ohchr-sso.html')

open("sso.txt", 'w') do |f|
  f.puts "Source Text	Translated Text	Media UUID	Phonetic Text	Video File Name	Phrase UUID	Language Code"
  eng_phrases = eng.phrases
  sso.phrases.each_with_index do |sso_phrase, index|
    f.puts "#{sso_phrase}\t#{eng_phrases[index]}"
  end
end


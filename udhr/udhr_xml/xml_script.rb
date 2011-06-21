doc = Nokogiri::XML(open('udhr_xml/index.xml'))
#language_codes = doc.xpath('udhrs/udhr/@iso639-3').map(&:value)
# 395 total

udhrs = doc.xpath('udhrs/udhr')
codes = []
udhrs.each do |u|
  stage = u.xpath('@stage').first.value
  code =  u.xpath('@iso639-3').first.value
  # puts "#{code} #{stage}"
  if stage  == "4" && code != ""
    codes << code
  end
end
# 359 stage 4 documents




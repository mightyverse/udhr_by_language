require './index'

codes = ["aac", "aau", "amm", "ank", "aon", "aso", "asx", "aup", "aup", "awi", "bcw", "bcy", "bde", "bef", "bfh", "bfh", "bhg", "bio", "bjc", "bji", "bjr", "bvr", "bvw", "cdc", "cdc", "cie", "ckl", "dah", "dds", "deu", "dge", "dgh", "dia", "djd", "djm", "dkl", "drs", "dtk", "duc", "eng", "ewe", "fag", "fai", "fli", "for", "fqs", "fra", "frq", "gaa", "gah", "gao", "gaz", "gbe", "gde", "gdf", "gdu", "gim", "gji", "gkn", "glw", "gnm", "gqa", "gqa", "gsp", "hau", "hdy", "hig", "hig", "hig", "hwo", "hya", "idi", "ife", "ind", "ino", "jim", "jma", "jow", "kbb", "kbx", "kig", "kit", "klq", "knc", "kol", "kqb", "kqc", "kqc", "ktb", "kun", "kvj", "kyx", "lme", "lme", "maf", "mcc", "mcn", "mfl", "mfm", "mfm", "mjs", "mnm", "moz", "mps", "mrt", "mse", "msy", "mti", "mtv", "mty", "mzu", "nbh", "nga", "nid", "nig", "nja", "nkg", "nwr", "okv", "onj", "pip", "plj", "ppo", "rwo", "sbf", "sid", "spa", "stk", "sur", "tan", "tbd", "tei", "tgu", "tlf", "ttr", "ufi", "urx", "uvh", "waj", "wbp", "wei", "wla", "wmo", "wnd", "wnp", "wrm", "wrr", "wsr", "ygr", "ymb", "yor", "yss", "zim"]

  def index
    lang_info = {}
    index_filename = File.join(File.dirname(__FILE__), "udhr_xml", "index.xml")
    File.open(index_filename)  do |f|
      docs = Nokogiri::XML(f).css('udhr')
      docs = docs.find_all { |doc| doc['iso639-3'] != '' and doc['stage'] >= '4' }      
      docs.each do |doc| 
        link_name = doc['l']
        link_name += "_#{doc['v']}" unless doc['v'].nil? or doc['v'] == ""
        data = { :name => doc['n'], :code => doc['iso639-3'], :unicode_link => "http://unicode.org/udhr/d/udhr_#{link_name}.html" } 
        lang_info[data[:code]] = data[:name]
      end

    end
   # lang_info.uniq! { |i| i[:code] }
    lang_info
  end


$info = index

$info.each do |code, name|
  puts "#{code} - #{name}"
end


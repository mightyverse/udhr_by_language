# see fair use guidelines: http://www.ethnologue.com/FairUseGuidelines.pdf
# Up to 10% or 2500 fields or cell entries, whichever is less
# 350 / 6700 is 5.2%
require 'sinatra'
require './ethnologue/language_info'
require './udhr/index'

get '/' do
  @lang_info = [ {:name => "English", :iso639_3 => 'eng'},
                {:name => "German", :iso639_3 => 'deu'},
                {:name => "Mandarin", :iso639_3 => 'cmn'},
                {:name => "Afrikaans", :iso639_3 => 'afk'},
                {:name => "Spanish", :iso639_3 => 'spa'},
                {:name => "Lingala", :iso639_3 => 'lin'}]
  @lang_info = UDHR::lang_info

  @world_pop =  6775235700
  @lang_info.each do |info|
    puts "info==>#{info.inspect}"
    size = Ethnologue::LanguageInfo.new(info[:iso639_3]).total_population
    info[:size] = size
    info[:percent] = sprintf("%0.2f%", size.to_f / @world_pop * 100)
  end

  @lang_info.sort! { |a,b|  a[:size] <=> b[:size] }
  @lang_info.reverse!

  largest = @lang_info.first[:size]
  @lang_info.each do |info|
    info[:display_percent] = info[:size].to_f / largest 
  end

  erb :languages
  
end

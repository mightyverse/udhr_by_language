# see fair use guidelines: http://www.ethnologue.com/FairUseGuidelines.pdf
# Up to 10% or 2500 fields or cell entries, whichever is less
# 350 / 6700 is 5.2%
require 'sinatra'
require './ethnologue/language_info'
require './udhr/index'

get '/' do
  @lang_info = UDHR::index

  @world_pop =  6775235700
  @lang_info.each do |info|
    puts "info==>#{info.inspect}"
    size = Ethnologue::LanguageInfo.new(info[:code]).total_population
    info[:size] = size
    percent = size.to_f / @world_pop * 100
    percent_str = sprintf("%0.2f%", percent)
    percent_str = sprintf("%0.3f%", percent) if percent < 0.15
    percent_str = sprintf("%0.4f%", percent) if percent < 0.05
    percent_str = sprintf("%0.5f%", percent) if percent < 0.005
    percent_str = sprintf("%0.6f%", percent) if percent < 0.0005
    info[:percent] = percent_str
  end

  @lang_info.sort! { |a,b|  a[:size] <=> b[:size] }
  @lang_info.reverse!

  largest = @lang_info.first[:size]
  @lang_info.each do |info|
    info[:display_percent] = info[:size].to_f / largest 
  end

  erb :languages
  
end

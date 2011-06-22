require 'open-uri'
require 'nokogiri'

module Ethnologue
  BASE_URL = "http://www.ethnologue.com/show_language.asp?code="
  class LanguageInfo
    attr_reader :total_population
    def initialize(code)
      @total_population = 0
      File.open("./cache/#{code}.html") do |f|
        match = f.read.scan(/Population total all countries:\s*(.*)\./)
        if match.nil? or match.first.nil?
          puts "#{code} match is #{match.inspect}"
        else 
          @total_population = match.first.first.split(',').join.to_i
        end
      end
    end

    def self.init_cache(codes = [])
      unless Dir.exists?('cache')
        `mkdir cache`
      end
      codes.each do |code|
        open(BASE_URL+code) do |f|
          page_content = f.read
          File.open("./cache/#{code}.html", "w") do |cache_file|
            cache_file.puts page_content
          end
        end
      end
    end
  end
end

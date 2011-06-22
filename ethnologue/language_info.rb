require 'open-uri'
require 'nokogiri'

module Ethnologue
  BASE_URL = "http://www.ethnologue.com/show_language.asp?code="
  class LanguageInfo
    attr_reader :total_population
    
    def initialize(code)
      @total_population = 0
      filename = LanguageInfo.fetch(code)
      File.open(filename) do |f|
        match = f.read.scan(/Population total all countries:\s*(.*)\./)
        if match.nil? or match.first.nil?
          puts "#{code} match is #{match.inspect}"
        else 
          @total_population = match.first.first.split(',').join.to_i
        end
      end
    end

    def self.fetch(code)
      unless Dir.exists?('cache')
        `mkdir cache`
      end
      filename = "./cache/#{code}.html"
      unless File.exists?(filename) 
        open(BASE_URL+code) do |f|
          page_content = f.read
          File.open(filename, "w") do |cache_file|
            cache_file.puts page_content
          end
        end
      end
      filename
    end
    def self.init_cache(codes = [])
      codes.each do |code|
        fetch(code) 
      end
    end
  end
end

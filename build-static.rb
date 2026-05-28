require 'erb'
require './ethnologue/language_info'
require './udhr/index'

OUTPUT_DIR = 'docs'
WORLD_POP  = 6_775_235_700

def number_with_delimiter(number, delimiter = ',')
  number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
end

# --- build data (same logic as app.rb's get '/' block) ---

lang_info = UDHR::index

lang_info.each do |info|
  size = Ethnologue::LanguageInfo.new(info[:code]).total_population
  info[:size] = size
  info[:size_str] = number_with_delimiter(size)

  percent = size.to_f / WORLD_POP * 100
  percent_str = sprintf('%0.2f%%', percent)
  percent_str = sprintf('%0.3f%%', percent) if percent < 0.15
  percent_str = sprintf('%0.4f%%', percent) if percent < 0.05
  percent_str = sprintf('%0.5f%%', percent) if percent < 0.005
  percent_str = sprintf('%0.6f%%', percent) if percent < 0.0005
  info[:percent] = percent_str
end

lang_info = lang_info.select { |info| info[:size] > 0 }
lang_info.sort_by! { |info| info[:size] }.reverse!

population = lang_info.sum { |info| info[:size] }
puts "---> #{population} (#{sprintf('%.2f', population.to_f / WORLD_POP * 100)}% of world population)"

largest = lang_info.first[:size]
lang_info.each { |info| info[:display_percent] = info[:size].to_f / largest }

# --- render templates ---

# Render the _language partial for each language, then inject into the main template.
# ERB doesn't have built-in partials, so we replicate Sinatra's erb :_language behavior.
@lang_info  = lang_info
@world_pop  = WORLD_POP
@population = population
@lang_items = lang_info.map do |lang|
  <<~HTML
    <li>
      <p class="name"><a href="#{lang[:unicode_link]}" target="#{lang[:code]}">#{lang[:name]}</a></p>
      <div class="graph">
        <div style="width:#{500 * lang[:display_percent]}px;margin-left:#{(500 - 500 * lang[:display_percent]) / 2}px" class="bar"></div>
      </div>
      <p>#{lang[:percent]}&nbsp;&nbsp;&nbsp;<a href="http://www.ethnologue.com/show_language.asp?code=#{lang[:code]}" target="_eth#{lang[:code]}">#{lang[:size_str]}</a></p>
    </li>
  HTML
end.join

languages_template = ERB.new(File.read('views/languages.erb'))
output_html = languages_template.result(binding)

# --- write output ---

Dir.mkdir(OUTPUT_DIR) unless Dir.exist?(OUTPUT_DIR)
out_path = File.join(OUTPUT_DIR, 'index.html')
File.write(out_path, output_html)
puts "Written to #{out_path}"

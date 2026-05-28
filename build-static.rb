require 'erb'
require 'net/http'
require 'nokogiri'
require './ethnologue/language_info'
require './udhr/index'

OUTPUT_DIR      = 'docs'
UDHR_DIR        = File.join(OUTPUT_DIR, 'udhr')
WORLD_POP       = 6_775_235_700
EFELE_BASE      = 'http://efele.net/udhr/d'

def number_with_delimiter(number, delimiter = ',')
  number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
end

# Fetch the UDHR XML for a language code slug (e.g. "cmn_hans").
# Returns a Nokogiri::XML::Document or nil if missing/unreachable.
def fetch_udhr_xml(slug)
  url = "#{EFELE_BASE}/udhr_#{slug}.xml"
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  case response
  when Net::HTTPSuccess
    Nokogiri::XML(response.body)
  when Net::HTTPNotFound
    nil
  else
    abort "Build failed: unexpected #{response.code} fetching #{url}"
  end
rescue => e
  abort "Build failed: network error fetching #{url}: #{e.message}"
end

# Render a UDHR XML document to a simple HTML page.
def render_udhr_page(lang, doc)
  title   = lang[:name]
  # UDHR XML uses <article>, <preamble>, <note>, <para> elements
  body_html = doc.css('udhr > *').map do |node|
    case node.name
    when 'title'    then "<h1>#{node.text.strip}</h1>"
    when 'note'     then "<p class=\"note\">#{node.text.strip}</p>"
    when 'preamble' then render_section(node)
    when 'article'  then render_section(node)
    else                 ''
    end
  end.join("\n")

  <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <title>#{title} – Universal Declaration of Human Rights</title>
      <link rel="stylesheet" href="../../style.css">
    </head>
    <body>
      <p><a href="../../index.html">&larr; All languages</a></p>
      #{body_html}
    </body>
    </html>
  HTML
end

def render_section(node)
  header = node.at_css('title')&.text&.strip
  paras  = node.css('para').map { |p| "<p>#{p.text.strip}</p>" }.join("\n")
  header_html = header ? "<h2>#{header}</h2>" : ''
  "<section>#{header_html}#{paras}</section>"
end

# --- build data ---

lang_info = UDHR::index

lang_info.each do |info|
  size = Ethnologue::LanguageInfo.new(info[:code]).total_population
  info[:size]     = size
  info[:size_str] = number_with_delimiter(size)

  percent     = size.to_f / WORLD_POP * 100
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

# --- fetch UDHR pages and note which languages have one ---

Dir.mkdir(OUTPUT_DIR) unless Dir.exist?(OUTPUT_DIR)
Dir.mkdir(UDHR_DIR)   unless Dir.exist?(UDHR_DIR)

lang_info.each do |lang|
  # Derive slug from the existing unicode_link, e.g.
  # http://efele.net/udhr/d/udhr_cmn_hans.html -> cmn_hans
  slug = lang[:unicode_link].to_s
            .split('/')
            .last
            .sub(/^udhr_/, '')
            .sub(/\.html$/, '')

  print "Fetching #{lang[:name]} (#{slug})... "
  doc = fetch_udhr_xml(slug)

  if doc
    page_path = File.join(UDHR_DIR, "#{slug}.html")
    File.write(page_path, render_udhr_page(lang, doc))
    lang[:local_page] = "udhr/#{slug}.html"
    puts "ok"
  else
    lang[:local_page] = nil
    puts "missing, link omitted"
  end
end

# --- render index ---

@lang_info  = lang_info
@world_pop  = WORLD_POP
@population = population
@lang_items = lang_info.map do |lang|
  name_html = if lang[:local_page]
    "<a href=\"#{lang[:local_page]}\">#{lang[:name]}</a>"
  else
    lang[:name]
  end

  <<~HTML
    <li>
      <p class="name">#{name_html}</p>
      <div class="graph">
        <div style="width:#{500 * lang[:display_percent]}px;margin-left:#{(500 - 500 * lang[:display_percent]) / 2}px" class="bar"></div>
      </div>
      <p>#{lang[:percent]}&nbsp;&nbsp;&nbsp;#{lang[:size_str]}</p>
    </li>
  HTML
end.join

languages_template = ERB.new(File.read('views/languages.erb'))
File.write(File.join(OUTPUT_DIR, 'index.html'), languages_template.result(binding))
puts "Written to #{OUTPUT_DIR}/index.html"

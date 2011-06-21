require 'webmock/rspec'
require './language_info'

#    codes = %w(afk cmn deu eng lin spa) 

def fixture_file(code)
  result = ""
  File.open("./fixtures/#{code}.html") do |f|
    result = f.read
  end
  result
end

describe Ethnologue do
  include WebMock::API

  it "should define a base URL" do
    Ethnologue::BASE_URL.should ==  "http://www.ethnologue.com/show_language.asp?code=" 
  end

  describe "::LanguageInfo" do
    let(:lin_page) { fixture_file("lin") }
    let(:eng_page) { fixture_file("eng") }
    
    let(:lin_url) {  "#{Ethnologue::BASE_URL}lin" }
    let(:eng_url) {  "#{Ethnologue::BASE_URL}eng" }

    let (:codes) {  %w(lin eng) }

    before do
      stub_request(:get, lin_url).to_return(:body => lin_page)
      stub_request(:get, eng_url).to_return(:body => eng_page)
      Ethnologue::LanguageInfo.init_cache(codes)      
    end

    it "should fetch language on demand" do
      WebMock.should have_requested(:get, lin_url)
      WebMock.should have_requested(:get, eng_url)
    end

    it "should cache language pages" do
      File.should exist('./cache/lin.html')
      File.should exist('./cache/eng.html')
    end

    it "should report language population" do
      Ethnologue::LanguageInfo.new('eng').total_population.should == 328008138
      Ethnologue::LanguageInfo.new('lin').total_population.should == 2141300
    end
  end
end

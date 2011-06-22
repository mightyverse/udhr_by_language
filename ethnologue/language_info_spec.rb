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
    before do
      `rm -rf cache`
      @codes =  %w(lin eng afk ace arb)
      @url = {}
      @page = {}
      @codes.each do |code|
        @url[code] = "#{Ethnologue::BASE_URL}#{code}"
        @page[code] = fixture_file(code)
      end
    end

   describe "with cached results" do
      before do
        @codes = @codes - ['afk']
        @codes.each do |code|
          stub_request(:get, @url[code]).to_return(:body => @page[code])        
        end
        Ethnologue::LanguageInfo.init_cache(@codes)      
      end
      it "should fetch language on demand" do
        @codes.each do |code|
          WebMock.should have_requested(:get, @url[code])
        end
      end

      it "should cache language pages" do
        File.should exist('./cache/lin.html')
        File.should exist('./cache/eng.html')
      end

      it "should report language population" do
        Ethnologue::LanguageInfo.new('eng').total_population.should == 328008138
        Ethnologue::LanguageInfo.new('lin').total_population.should == 2141300

        # these have diff formatting
        Ethnologue::LanguageInfo.new('ace').total_population.should == 3500000
        Ethnologue::LanguageInfo.new('arb').total_population.should == 206000000

      end
      
    end
    it "should fetch a language if not cached" do
      stub_request(:get, @url['afk']).to_return(:body => @page['afk'])            
      Ethnologue::LanguageInfo.new('afk').total_population.should == 4934950
      WebMock.should have_requested(:get, @url['afk'])      
      File.should exist('./cache/afk.html')

    end

  end
end

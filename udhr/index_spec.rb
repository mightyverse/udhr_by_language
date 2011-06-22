require File.join(File.dirname(__FILE__), '/index')

describe "UDHR::index" do
  let(:index) { UDHR.index }
 
  it "returns a non empty array" do
    index.should_not be_empty
  end

  it "should ignore results with null codes, so first result is Abkhaz" do
    abk = index.first
    abk.should_not be_nil
    abk[:name].should == "Abkhaz"
    abk[:code].should == 'abk'
  end

  it "should exclude languages that are less than stage 4" do
    index.find { |info| info[:code] == "asm" }.should be_nil
  end

  it "should include languages that are stage 4 and greater" do
    index.find { |info| info[:code] == "eng" }.should_not be_nil
  end

  it "should return one result per code" do
    deu_results = index.find_all { |info| info[:code] == "deu" }
    deu_results.length.should == 1

  end
end


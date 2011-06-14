$LOAD_PATH << "."
require 'article'

describe Article do
  describe "with just text" do
    let(:article) { Article.new("Article 1", ["Humans have rights"]) }
    it "has a heading" do
      article.heading.should == "Article 1"
    end
    it "has text" do
      article.text.should == ["Humans have rights"]
    end
    it "has numbered sections" do
      article.sections.should == []
    end
    it "has phrases" do
      article.phrases.should == ["Article 1", "Humans have rights"]
    end
  end

  describe "with sections" do
    let(:article) { Article.new("Article 2", nil, ["One thing.", "Another thing."]) }
    it "has a heading" do
      article.heading.should == "Article 2"
    end
    it "has text" do
      article.text.should == []
    end
    it "has numbered sections" do
      article.sections.should == ["One thing.", "Another thing."]
    end
    it "has phrases" do
      article.phrases.should == ["Article 2", "One thing.", "Another thing."]
    end
  end

  describe "setters" do
    let(:article) { Article.new("Article 3") }

    it "can set text" do
      article.text = ["Something"]
      article.text.should == ["Something"]
    end

    it "can set sections" do
      article.sections = ["Section 1"]
      article.sections.should == ["Section 1"]
    end

  end
  
end

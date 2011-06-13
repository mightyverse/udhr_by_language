$LOAD_PATH << '.'
require 'text_extractor'

describe "UDHR::Document" do
  describe "text extraction" do 
    it "requires a filename on creation" do
      lambda {
        doc = UDHR::Document.new
      }.should raise_error(ArgumentError)
    end

    describe "with valid doc from general UN site" do
      # http://www.un.org/en/documents/udhr/index.shtml
      let(:doc) { UDHR::Document.new('./fixtures/en.html') }
      it "provides full HTML as Nokogiri doc" do
        doc.html.should be_a(Nokogiri::HTML::Document)
      end

      it "provides an array of phrases including article headings" do
        doc.phrases.should include("Article 1.")
        doc.phrases.should include("Article 30.")
      end

      it "gets article contents without extra white space" do
        doc.phrases.should include("Everyone has the right to work, to free choice of employment, to just and favourable conditions of work and to protection against unemployment.")
      end
    end

    describe "with english doc from general OHR UN site" do
      # http://www.ohchr.org/EN/UDHR/Pages/Language.aspx?LangID=eng
      let(:doc) { UDHR::Document.new('./fixtures/ohchr-eng.html') }

      it "provides an array of phrases including article headings" do
        doc.phrases.should include("Article 1")
        doc.phrases.should include("Article 30")
      end

      it "gets Article 26.1 without extra white space" do
        doc.phrases.should include("Everyone has the right to education. Education shall be free, at least in the elementary and fundamental stages. Elementary education shall be compulsory. Technical and professional education shall be made generally available and higher education shall be equally accessible to all on the basis of merit.")
      end
      it "gets Article 23.2 contents without extra white space" do
        doc.phrases.should include("Everyone has the right to freedom of movement and residence within the borders of each State.")
      end
    end

    describe "clean text" do
      it "removes leading spaces" do
        UDHR::Document.clean_text("  Something here.").should == "Something here."
      end
      it "removes trailing spaces" do
        UDHR::Document.clean_text("Something here.   ").should == "Something here."
      end
      it "removes double spaces" do
        UDHR::Document.clean_text("Something    is  here.").should == "Something is here."
      end
      it "removes leading numbers in parens" do
        UDHR::Document.clean_text("(3) Something here.").should == "Something here."
      end
      it "removes leading numbers in parens with extra whitespace" do
        UDHR::Document.clean_text("  ( 3 )   Something here.").should == "Something here."
      end 
    end

  end
end

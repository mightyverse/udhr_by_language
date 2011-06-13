# encoding: utf-8
$LOAD_PATH << '.'
require 'text_extractor'

describe "UDHR::Document" do
  describe "text extraction" do 
    it "requires a filename on creation" do
      lambda {
        doc = UDHR::Document.new
      }.should raise_error(ArgumentError)
    end

    describe "with english doc from general OHR UN site" do
      # http://www.ohchr.org/EN/UDHR/Pages/Language.aspx?LangID=eng
      let(:doc) { UDHR::Document.new('./fixtures/ohchr-eng.html') }

      it "provides an array of phrases including article headings" do
        doc.phrases.should include("Article 30")
      end

      it "should begin with the first Article" do
        doc.phrases.first.should == "Article 1"
      end

      it "should have the text of the first Article as the second phrase" do
        doc.phrases[1].should ==  "All human beings are born free and equal in dignity and rights. They are endowed with reason and conscience and should act towards one another in a spirit of brotherhood."
      end

      it "gets Article 26.1 without extra white space" do
        doc.phrases[66].should == "Everyone has the right to education. Education shall be free, at least in the elementary and fundamental stages. Elementary education shall be compulsory. Technical and professional education shall be made generally available and higher education shall be equally accessible to all on the basis of merit."
      end
      it "gets Article 23.2 contents without extra white space" do
        doc.phrases[57].should == "Everyone, without any discrimination, has the right to equal pay for equal work."
      end
    end

    describe "with german doc from general OHR UN site" do
      # http://www.ohchr.org/EN/UDHR/Pages/Language.aspx?LangID=eng
      let(:doc) { UDHR::Document.new('./fixtures/ohchr-ger.html') }

      it "provides an array of phrases including article headings" do
        doc.phrases.should include("Artikel 30")
      end

      it "should begin with the first Article" do
        doc.phrases.first.should == "Artikel 1"
      end

      it "should have the text of the first Article as the second phrase" do
        doc.phrases[1].should ==  "Alle Menschen sind frei und gleich an Würde und Rechten geboren. Sie sind mit Vernunft und Gewissen begabt und sollen einander im Geiste der Brüderlichkeit begegnen."
      end
      it "gets Article 23.2 contents without extra white space" do
        doc.phrases[57].should == "Jeder, ohne Unterschied, hat das Recht auf gleichen Lohn für gleiche Arbeit."
      end
      
      it "gets Article 26.1 without extra white space" do
        doc.phrases[66].should == "Jeder hat das Recht auf Bildung. Die Bildung ist unentgeltlich, zum mindesten der Grundschulunterricht und die grundlegende Bildung. Der Grundschulunterricht ist obligatorisch. Fach- und Berufsschulunterricht müssen allgemein verfügbar gemacht werden, und der Hochschulunterricht muß allen gleichermaßen entsprechend ihren Fähigkeiten offenstehen."
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
      it "removes leading numbers with ." do
        UDHR::Document.clean_text("3. Something here.").should == "Something here."
      end
      it "removes leading numbers with dots with extra whitespace" do
        UDHR::Document.clean_text("  3.   Something here.").should == "Something here."
      end 
      
      it "leaves text with no spaces intact" do
        UDHR::Document.clean_text("Something").should == "Something"
      end
    end

  end
end

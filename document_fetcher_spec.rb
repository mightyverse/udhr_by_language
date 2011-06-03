load 'document_fetcher.rb'

describe DocumentFetcher do

  describe '.fetch' do

    before do
      Object.stub!(:open)
      Nokogiri.stub!(:HTML) do
        mock = double
        mock.stub!(:css)
        mock
      end
      Nokogiri::HTML::Document.any_instance.stub!(:css)
    end

    it "should make a get request to the given URL" do
      Object.should_receive(:open).with('http://foo.com')

      DocumentFetcher.fetch('http://foo.com')
    end

    context "when parsing" do
      before do
        File.open("foo.com", "w") do |f|
          f << "some text"
        end
      end

      after do
        `rm foo.com`
      end

      it "should parse the response from a URL" do
        response = open('foo.com')
        Object.should_receive(:open).with('http://foo.com') { response }
        Nokogiri.should_receive(:HTML).with(response)

        DocumentFetcher.fetch('http://foo.com')
      end
    end

    it "should get the DOM for the declaration of human rights" do
      doc = Nokogiri::HTML <<-HTML
        <html>
        <body>
        <div>foo</div>
        <span class="udhrtext">Human rights!</span>
        <div>bar</div>
        </body>
        </html>
      HTML

      Object.should_receive(:open) { "string_to_be_parsed" }
      Nokogiri.should_receive(:HTML).with("string_to_be_parsed") { doc }
      doc.should_receive(:css).with('span.udhrtext')

      DocumentFetcher.fetch('http://foo.com')
    end

  end

end
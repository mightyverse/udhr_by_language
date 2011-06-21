class Article
  attr_accessor :heading, :text, :sections

  def initialize(heading, text=[], sections=[])
    @heading = heading
    @text = text
    @text ||= []
    @sections = sections
  end

  def phrases
    result = [@heading]
    result += text 
    result += sections
  end
end

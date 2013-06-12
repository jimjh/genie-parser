require 'spec_helper'

describe Spirit::Render::Processors::PygmentsProcessor do

  let(:processor) { Spirit::Render::Processors::PygmentsProcessor.new }
  let(:code) { <<-eos
      def hello_word
        puts 'hello_word'
      end
    eos
  }
  subject { processor }

  RSpec::Matchers.define :be_highlighted do
    match do |html|
      doc = Nokogiri::HTML::Document.parse html
      !doc.css('div.highlight pre').empty?
    end
  end

  it 'highlights the code' do
    html = processor.highlight_code code, 'ruby'
    html.should be_highlighted
  end

  it 'defaults to text' do
    html = processor.highlight_code code, nil
    html.should be_highlighted
  end

end


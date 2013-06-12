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

  it 'highlights the code' do
    output = processor.highlight_code code, 'ruby'
    output.should include 'highlight'
  end

  it 'defaults to text' do
    output = processor.highlight_code code, nil
    output.should include 'highlight'
  end

end


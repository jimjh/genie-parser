require 'spec_helper'

describe Spirit::Render::Processors::BlockImageProcessor do

  let(:processor) { Spirit::Render::Processors::BlockImageProcessor.new }
  subject { processor }

  CSS_CLASS = '.block-image'

  context 'given a valid block image' do
    let(:cap_1)  { Faker::Lorem.words.join ' ' }
    let(:cap_2)  { Faker::Lorem.words.join ' ' }
    let(:text_1) { "   <img src='abc' alt='#{cap_1}'/>\n   " }
    let(:text_2) { "<img src='abc' alt='#{cap_2}'/>" }
    it 'detects block images' do
      processor.filter(text_1).should match CSS_CLASS
      processor.filter(text_2).should match CSS_CLASS
    end
    it 'adds a caption' do
      processor.filter(text_1).should match /#{cap_1}\s*<\/p>/
      processor.filter(text_2).should match /#{cap_2}\s*<\/p>/
    end
    it 'adds figure numbers' do
      processor.filter(text_1).should include "Figure 1"
      processor.filter(text_2).should include "Figure 2"
    end
  end

  shared_examples 'falls back to paragraph text' do
    it 'falls back to paragraph text' do
      processor.filter(text).should eq "<p>#{text}</p>"
    end
  end

  context 'given text that fails the regex test' do
    let(:text) { SecureRandom.uuid }
    include_examples 'falls back to paragraph text'
  end

  context 'given text that fails the nikogiri test' do
    let(:text) { "    ><img #{SecureRandom.uuid} >\n    " }
    include_examples 'falls back to paragraph text'
  end

end

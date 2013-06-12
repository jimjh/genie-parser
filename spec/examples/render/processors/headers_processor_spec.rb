require 'ostruct'
require 'spec_helper'

describe Spirit::Render::Processors::HeadersProcessor do

  let(:renderer)  { OpenStruct.new nesting: nil, navigation: nil }
  let(:processor) { Spirit::Render::Processors::HeadersProcessor.new renderer }
  let(:text)      { Faker::Lorem.sentence }
  let(:level)     { Random.rand(5) + 1 }
  let(:html)      { processor.header text, level }
  let(:doc)       { Nokogiri::HTML::Document.parse html }
  subject { processor }

  it 'creates headers' do
    headers = doc.css("h#{level + 1}")
    headers.first.text.strip.should eq text
  end

  it 'increases header levels by 1' do
    headers = doc.css("h#{level + 1}")
    headers.first.text.strip.should eq text
  end

  it 'adds h1s to the navigation bar' do
    processor
    renderer.navigation.count.should eq 0
    processor.header text, 1
    processor.header text, 2
    processor.header text, 3
    processor.header text, 1
    processor.header text, 1
    renderer.navigation.count.should eq 3
  end

  describe 'nesting' do

    it 'handles chains' do
      processor.header text, 1
      processor.header text, 2
      processor.header text, 3
      renderer.nesting.size.should be 3
    end

    it 'handles breaks' do
      processor.header text, 1
      processor.header text, 2
      processor.header text, 3
      processor.header text, 3
      renderer.nesting.size.should be 3
    end

  end

end


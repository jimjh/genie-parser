require 'spec_helper'

describe Spirit::Render::Short do

  subject       { problem }
  let(:input)   { FactoryGirl.create :short }
  let(:problem) { Spirit::Render::Problem.parse input }

  it { should be_kind_of Spirit::Render::Short }

  it 'renders a short problem' do
    doc  = Nokogiri::HTML::Document.parse problem.render
    doc.css('input[type="text"]').should_not be_empty
  end

  context 'given missing answers' do
    let(:input) { FactoryGirl.create :short, answer: nil }
    include_examples 'invalid problem'
  end

end

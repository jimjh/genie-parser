require 'spec_helper'

describe Spirit::Render::Multi do

  let(:input)   { FactoryGirl.create :multi }
  let(:problem) { Spirit::Render::Problem.parse input }
  subject { problem }

  it { should be_kind_of Spirit::Render::Multi }

  it 'renders a multiple choice problem' do
    html = problem.render
    doc  = Nokogiri::HTML::Document.parse html
    doc.css('input[type="radio"]').should_not be_empty
  end

  context 'given non-string answers' do
    let(:input) { FactoryGirl.create :multi, answer: 16 }
    include_examples 'invalid problem'
  end

  context 'given missing options' do
    let(:input) { FactoryGirl.create :multi, options: nil }
    include_examples 'invalid problem'
  end

  context 'given non-hash options' do
    let(:input) { FactoryGirl.create :multi, options: 'string' }
    include_examples 'invalid problem'
  end

end

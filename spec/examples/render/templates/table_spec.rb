require 'spec_helper'

describe Spirit::Render::Table do

  subject       { problem }
  let(:input)   { FactoryGirl.create :table }
  let(:problem) { Spirit::Render::Problem.parse input }

  it { should be_kind_of Spirit::Render::Table }

  it 'renders a table problem' do
    doc  = Nokogiri::HTML::Document.parse problem.render
    doc.css('table').should_not be_empty
  end

  context 'given missing grid' do
    let(:input) { FactoryGirl.create :table, grid: nil }
    include_examples 'invalid problem'
  end

  context 'given non-array grids' do
    let(:input) { FactoryGirl.create :table, grid: Faker::Lorem.words }
    include_examples 'invalid problem'
  end

  context 'given non-grid answers' do
    let(:input) { FactoryGirl.create :table, answer: 16 }
    include_examples 'invalid problem'
  end

end


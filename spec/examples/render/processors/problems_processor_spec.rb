require 'spec_helper'
require 'ostruct'

describe Spirit::Render::Processors::ProblemsProcessor do

  let(:nesting)   { %w[h1 h2 h3] }
  let(:renderer)  { OpenStruct.new problems: nil, nesting: nesting.dup }
  let(:processor) { Spirit::Render::Processors::ProblemsProcessor.new renderer }
  subject { processor }

  let(:problem_1) { FactoryGirl.create :short }
  let(:problem_2) { FactoryGirl.create :short }
  let(:problem_3) { FactoryGirl.create :short, question: nil }
  let(:random_text) { Faker::Lorem.words.join ' ' }
  let(:problems_yaml) do <<-YAML
"""
#{problem_1}
"""
#{random_text}
"""
#{problem_2}
"""
"""
#{problem_3}
"""
  YAML
  end


  describe '#filter' do
    let(:filtered)  { processor.filter problems_yaml }
    it 'replaces problems with markers' do
      filtered.should include "<!-- %%0%% -->"
      filtered.should include "<!-- %%1%% -->"
    end
    it 'falls back to text' do
      filtered.should include random_text
    end
    it 'collects problems and solutions' do
      filtered
      processor.problems.size.should  == 2
      processor.solutions.size.should == 2
    end
  end

  describe '#replace' do
    before(:each) { processor.filter problems_yaml }
    let(:nesting) { Faker::Lorem.words }
    it 'replaces markers' do
      processor.replace("  <!-- %%0%% -->").should eq ''
      processor.replace("  <!-- %%1%% -->\n").should eq ''
    end
    it 'ignores pseudo markers' do # index out of bounds
      processor.replace("<!-- %%2%% -->").should eq "<!-- %%2%% -->"
    end
    it 'updates nesting' do
      processor.replace("<!-- %%1%% -->")
      processor.problems[1].nesting.should eq nesting
    end
  end

  describe '#problems' do
    before(:each) { processor.filter problems_yaml }
    it 'returns parsed problems' do
      processor.problems[0].question.should include YAML.load(problem_1)['question']
    end
  end

  describe '#solutions' do
    before(:each) { processor.filter problems_yaml }
    it 'returns parsed solutions' do
      processor.solutions.size.should eq 2
      processor.solutions.each do |s|
        s.should have_key :digest
        s.should have_key :solution
      end
    end
  end

  %i[size count each each_with_index].each do |f|
    it { should respond_to f }
  end

end


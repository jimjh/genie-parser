# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit::Render::Problem do

  def parse(*args); Spirit::Render::Problem.parse *args; end

  subject     { parse input }
  let(:input) { FactoryGirl.create(:short) }

  shared_examples 'render error' do
    it 'raises a RenderError' do
      expect { parse input }.to raise_error Spirit::Render::RenderError
    end
  end

  shared_examples 'no render error' do
    it 'does not raise a RenderError' do
      expect { parse input }.to_not raise_error Spirit::Render::RenderError
    end
  end

  describe '::parse' do

    context 'given valid YAML markup' do
      it { should be_kind_of(Spirit::Render::Problem) }
      include_examples 'no render error'
    end

    context 'given invalid YAML markup' do

      context 'that are not associative arrays' do
        %w({xxx} [[?]] [["?"]]).each do |input|
          let(:input) { input }
          include_examples 'render error'
        end
      end

      context 'that are missing formats' do
        let(:input) { FactoryGirl.create(:short, format: nil) }
        include_examples 'render error'
      end

      context 'that have invalid formats' do
        %w(w x ?).each do |format|
          let(:input) { FactoryGirl.create(:short, format: format) }
          include_examples 'render error'
        end
      end

      context 'that do not have string questions' do
        let(:input) { FactoryGirl.create(:short, question: ['x']) }
        include_examples 'render error'
      end

      context 'that do not have questions' do
        let(:input) { FactoryGirl.create(:short, question: nil) }
        include_examples 'render error'
      end

    end

    context 'given problems with valid formats in different cases' do
      %w(short Short SHORT shORt).each do |format|
        let(:input) { FactoryGirl.create(:short, format: format) }
        include_examples 'no render error'
      end
    end

  end

  describe '#valid?' do
    it { should be_valid }
    it 'does not accept missing answers' do
      text = FactoryGirl.create(:short, answer: nil)
      parse(text).should_not be_valid
    end
  end

  describe '#render' do
    its(:render) { should be_kind_of String }
    its(:render) { should match /Problem 1/ }
  end

end

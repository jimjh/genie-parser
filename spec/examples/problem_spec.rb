# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit::Render::Problem do

  def parse(yaml); Spirit::Render::Problem.parse yaml; end

  subject { parse input }
  let(:input) { FactoryGirl.create(:short) }

  describe '::parse' do

    context 'given invalid YAML markup' do

      context 'that are not associative arrays' do
        %w({xxx} [[?]] [["?"]]).each do |input|
          it 'raises a RenderError' do
            expect { parse input }.to raise_error(Spirit::Render::RenderError)
          end
        end
      end

      context 'that are missing formats' do
        let(:input) { FactoryGirl.create(:short, format: nil) }
        it 'raises a RenderError' do
          expect { parse input }.to raise_error(Spirit::Render::RenderError)
        end
      end

      context 'that have invalid formats' do
        let(:formats) { %w(w x ?) }
        it 'raises a RenderError' do
          formats.each do |format|
            input = FactoryGirl.create(:short, format: format)
            expect { parse input }.to raise_error(Spirit::Render::RenderError)
          end
        end
      end

      context 'that do not have string questions' do
        it 'raises a RenderError' do
          text = FactoryGirl.create(:short, question: ['x'])
          expect { parse text }.to raise_error(Spirit::Render::RenderError)
        end
      end

      context 'that do not have questions' do
        it 'raises a RenderError' do
          text = FactoryGirl.create(:short, question: nil)
          expect { parse text }.to raise_error(Spirit::Render::RenderError)
        end
      end

    end

    context 'given problems with valid formats in different cases' do
      %w(short Short SHORT shORt).each do |format|
        it 'does not raise a RenderError' do
          input = FactoryGirl.create(:short, format: format)
          expect { parse input }.to_not raise_error
        end
      end
    end

    context 'given valid YAML markup' do
      it { should be_kind_of(Spirit::Render::Problem) }
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
    its(:render) { should match /Problem 0/ }
  end

  describe '#save!' do
    its(:save!)  { should match /0\.sol/ }
    it 'saves the solution file to disk'
  end

end

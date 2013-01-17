# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit::Render::Problem do

  def parse(yaml); Spirit::Render::Problem.parse yaml; end
  let(:subject) { parse input }

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
      let(:input) { FactoryGirl.create(:short) }
      it { should be_kind_of(Spirit::Render::Problem) }
    end

  end

  describe '#valid?' do

    context 'given YAML markup' do

      it 'does not accept missing questions' do
        text = FactoryGirl.create(:short, question: nil)
        parse(text).should_not be_valid
      end

      it 'does not accept questions that are not strings' do
        text = FactoryGirl.create(:short, question: ['x'])
        parse(text).should_not be_valid
      end

      it 'does not accept missing answers' do
        text = FactoryGirl.create(:short, answer: nil)
        parse(text).should_not be_valid
      end

      it 'accepts complete questions' do
        text = FactoryGirl.create(:short)
        parse(text).should be_valid
      end

    end

  end

  describe '::new' do

    context 'without an ID' do
      let(:input) { FactoryGirl.create(:short, id: nil) }
      its(:id) { should_not be_empty }
    end

    context 'with an ID' do
      let(:id)    { SecureRandom.uuid }
      let(:input) { FactoryGirl.create(:short, id: id) }
      its(:id) { should eq id }
    end

  end

end

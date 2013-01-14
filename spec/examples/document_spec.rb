# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit::Document do

  subject { Spirit::Document.new(source, opts) }

  shared_examples 'document attributes' do
    it { should respond_to(:data)   }
    it { should respond_to(:engine) }
    its(:data) { should eq text }
  end

  context 'given a string source' do
    let(:text)   { Faker::Lorem.paragraph }
    let(:source) { text }
    let(:opts)   { Hash.new }
    include_examples 'document attributes'
  end

  context 'given an IO source' do
    let(:text)   { Faker::Lorem.paragraph }
    let(:source) { StringIO.new text }
    let(:opts)   { Hash.new }
    include_examples 'document attributes'
  end

  describe '#render' do

    it 'allows strikethroughs' do
      o = '<del>x</del>'
      Spirit::Document.new('~~x~~').render.should match(/#{o}/)
    end

    it 'autolinks' do
      o = 'xyz.com/</a>'
      Spirit::Document.new('http://xyz.com/').render.should match(/#{o}/)
    end

    it 'ignores intra emphasis' do
      o = 'no_intra_emphasis'
      Spirit::Document.new(o).render.should match(/#{o}/)
    end

    it 'allows tables' do
      o = '</table>'
      Spirit::Document.new(" x | y | z \n---|---|---").render.should match(/#{o}/)
    end

    it 'allows fenced code blocks' do
      o = '</pre>'
      Spirit::Document.new("```\nxyz\n```").render.should match(/#{o}/)
    end

    let(:string)   { SecureRandom.uuid }
    let(:document) { Spirit::Document.new string }

    context 'without an IO output' do
      subject { document.render }
      it { should be_a(String) }
    end

    context 'given an IO output' do
      let(:io) { StringIO.new }
      it 'writes the output to the given IO' do
        document.render(io).should be_a(Numeric)
        io.rewind
        io.read.should match(/#{string}/)
      end
    end

  end

end
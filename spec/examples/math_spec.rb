# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit::Render::Math do

  describe '#filter' do

    let(:filtered)  { Spirit::Render::Math.new(@input).preprocess }
    let(:the_usual) { /here is some @@0@@ and @@1@@/ }

    it 'filters inline math with markers' do
      @input  = 'here is some $x \in S$ and $y \in A$'
      filtered.should match the_usual
    end

    it 'filters block math with markers' do
      @input = 'here is some $$x \in S$$ and $$y \in A$$'
      filtered.should match the_usual
    end

    it 'filters env math with markers' do
      @input = 'here is some \begin{x}w\end{x} and \begin{x*}w\end{x*}'
      filtered.should match the_usual
    end

    it 'filters math markers with math markers' do
      @input = 'here is some @@124123@@ and @@123098@@'
      filtered.should match the_usual
    end

    it 'filters math with nested braces with markers' do
      @input = 'here is some $x {$$$} $ and $x {{}}{$}$'
      filtered.should match the_usual
    end

    it 'filters math with bad braces with markers' do
      @input = 'here is some $x {}$ and $y{$'
      filtered.should match the_usual
    end

    it 'ignores math that goes over 2 line breaks' do
      @input = "here is some $x\n\n $z$ and $y\n$"
      filtered.should match(/here is some \$x\n\n @@0@@ and @@1@@/)
    end

    it 'filters math with unmatched braces over 2 line breaks' do
      @input = "here is some $x{$\n\n and $y$"
      filtered.should match(/here is some @@0@@\n\n and @@1@@/)
    end

  end

  describe '#replace' do

    it 'replaces inline math' do
      o = '$x_i \in A_j$'
      Spirit::Document.new(o).render.should match(/\$x_i \\in A_j\$/)
    end

    it 'replaces block math' do
      o = '$$x_i \in A_j$$'
      Spirit::Document.new(o).render.should match(/\$\$x_i \\in A_j\$\$/)
    end

    it 'replaces latex env math' do
      o = '\begin{x}x_i \in A_j\end{x}'
      Spirit::Document.new(o).render.should match(/\\begin{x}x_i \\in A_j\\end{x}/)
    end

  end

end

describe Spirit::Render::Math::SPLIT do

  it { should match '\begin{x}' }
  it { should match '\end{x}' }
  it { should match '\begin{x*}' }
  it { should match '\end{x*}' }
  it { should match '$'  }
  it { should match '$$' }
  it { should match '\\\\' }
  it { should match '\{' }
  it { should match '\}' }
  it { should match '{' }
  it { should match '}' }
  it { should match "\n      \n" }
  it { should match '@@123@@' }

end

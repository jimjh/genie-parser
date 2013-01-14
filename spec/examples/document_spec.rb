# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit::Document do

  describe '::parse_document' do

    shared_examples 'alternative problem template' do
      it 'accepts and uses the given problem template class'
    end

    shared_examples 'IO object' do
      it 'writes the output to IO'
    end

    context 'given a valid document' do
      it 'parses the given document'
      it 'returns true'
      include_examples 'alternative problem template'
    end

    context 'given a parseable, invalid document' do
      it 'returns false'
      include_examples 'alternative problem template'
    end

    context 'given an unparseable document' do
      it 'raises Spirit::Error'
    end

  end

end

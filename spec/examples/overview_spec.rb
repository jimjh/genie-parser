# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit do

  describe '::initialize_logger' do
    it 'sets the log output'
  end

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

  describe '::parse_manifest' do
    it 'parses the given manifest'
    it 'raises Spirit::Error if the manifest is invalid'
  end

end

# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit do

  describe '::initialize_logger' do
    it 'sets the log output'
  end

  describe '::parse_document' do
    it 'parses the given document'
    it 'raises Spirit::Error if the document is invalid'
  end

  describe '::parse_manifest' do
    it 'parses the given manifest'
    it 'raises Spirit::Error if the manifest is invalid'
  end

end

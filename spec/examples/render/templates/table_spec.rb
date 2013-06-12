# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit::Render::Table do

  def parse(yaml); Spirit::Render::Table.parse yaml; end

  subject     { parse input }
  let(:input) { FactoryGirl.create :table }

  describe '::parse' do
    it { should be_kind_of Spirit::Render::Table }
  end

  it 'needs more specs'

end


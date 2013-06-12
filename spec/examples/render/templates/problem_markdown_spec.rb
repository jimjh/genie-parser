require 'spec_helper'

describe Spirit::Render::Problem do

  def render(yaml)
    Spirit::Render::Problem.parse(yaml).render
  end

  describe '::parse' do

    it 'allows markdown in the question text' do
      yaml = FactoryGirl.create(:short, question: '*hi*')
      exp  = '<em>hi</em>'
      render(yaml).should match(/#{exp}/)
    end

  end

end

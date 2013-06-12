shared_examples 'invalid problem' do
  it 'raises a RenderError' do
    expect { Spirit::Render::Problem.parse(input).render }
      .to raise_error Spirit::Render::RenderError
  end
end


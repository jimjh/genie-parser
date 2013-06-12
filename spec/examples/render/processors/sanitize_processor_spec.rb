require 'spec_helper'

describe Spirit::Document do

  # mostly trusting the sanitize gem
  describe 'sanitization' do

    subject { Spirit::Document.new(src).render }

    shared_examples 'strip malicious tags' do
      it { should_not match(/#{malicious_str}/) }
    end

    context 'given script tags' do
      let(:src) { "<script>alert('x');</script>" }
      let(:malicious_str) { '<script' }
      include_examples 'strip malicious tags'
    end

    context 'given style tags' do
      let(:src) { "<style>body { display: none; }</style>" }
      let(:malicious_str) { '<style' }
      include_examples 'strip malicious tags'
    end

    context 'given comments' do
      let(:src) { "<!-- this is a comment, could be used to hide scripts -->" }
      let(:malicious_str) { 'this is a comment' }
      include_examples 'strip malicious tags'
    end

    context 'given onclick attribute' do
      let(:src) { "<a href='http://google.com' onclick='alert(x)'>Click</a>" }
      let(:malicious_str) { 'alert(x)' }
      include_examples 'strip malicious tags'
    end

    context 'given data attributes' do
      let(:src) { "<a href='http://google.com' data-x='alert(x)'>Click</a>" }
      let(:malicious_str) { 'alert(x)' }
      include_examples 'strip malicious tags'
    end

    context 'given anchors' do
      let(:src) { "<a href='http://google.com'>Click</a>" }
      it 'adds rel="nofollow"' do
        output = 'href="http://google.com" rel="nofollow"'
        subject.should match(/#{output}/)
      end
    end

  end

end

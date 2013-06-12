require 'spec_helper'

describe Spirit::Manifest do

  shared_examples 'manifest parser' do

    context 'given a valid manifest' do
      let(:manifest) { FactoryGirl.create(:manifest).to_yaml }
      it { should be_a(Hash) }
      it { should eq(YAML.load manifest) }
    end

    context 'given an empty manifest' do
      let(:manifest) { Hash.new.to_yaml }
      it { should be_a(Hash) }
      it { should be_empty }
    end

    context 'given a manifest containing UTF-8 characters' do
      let(:manifest) { FactoryGirl.create(:manifest, title: '你好').to_yaml }
      its([:title]) { should eq('你好') }
    end

    context 'given a manifest containing a single string' do
      let(:manifest) { Faker::Lorem::paragraph.to_yaml }
      it 'raises Spirit::ManifestError' do
        msg = 'The manifest file should contain a dictionary'
        expect { subject }.to raise_error Spirit::ManifestError, /#{msg}/
      end
    end

    context 'given a manifest containing invalid YAML' do
      let(:manifest) { 'x: """' }
      it 'raises Spirit::ManifestError' do
        expect { subject }.to raise_error Spirit::ManifestError, /unexpected/i
      end
    end

    context 'given a manifest containing invalid scalars' do
      let(:manifest) { FactoryGirl.create(:manifest, title: 2.0).to_yaml }
      it 'raises Spirit::ManifestError' do
        msg = 'The title option in the manifest file should be a String'
        expect { subject }.to raise_error Spirit::ManifestError, /#{msg}/
      end
    end

    context 'given a manifest containing invalid arrays' do
      let(:manifest) { FactoryGirl.create(:manifest, categories: [2.0]).to_yaml }
      it 'raises Spirit::ManifestError' do
        msg = 'The categories option in the manifest file should contain a String'
        expect { subject }.to raise_error Spirit::ManifestError, /#{msg}/
      end
    end

  end

  describe '::load' do
    subject { Spirit::Manifest.load manifest }
    it_behaves_like 'manifest parser'
  end

  describe '::load_file' do

    before { @dir = Pathname.new Dir.mktmpdir }
    after   { FileUtils.remove_entry_secure @dir }

    context 'given a manifest file' do
      before  { File.open(@dir + 'manifest.yml', 'w+') { |f| f.write manifest } }
      subject { Spirit::Manifest.load_file @dir + 'manifest.yml' }
      it_behaves_like 'manifest parser'
    end

    context 'given a non-existent file' do
      it 'raises ENOENT if the file does not exist' do
        expect { Spirit::Manifest.load_file '/path/to/non-existent/file' }.to raise_error(Errno::ENOENT)
      end
    end

    context 'given a non-readable file' do
      before  { File.open(@dir + 'manifest.yml', 'w+', 0333) { |f| f.write '---' } }
      it 'raises ENOENT if the file does not exist' do
        expect { Spirit::Manifest.load_file '/path/to/non-existent/file' }.to raise_error(Errno::ENOENT)
      end
    end

  end

end

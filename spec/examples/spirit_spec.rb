# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe Spirit do

  it { should respond_to :logger }

  describe '::initialize_logger' do

    context 'given a temporary file' do

      let(:tmp_file)   { Pathname.new(Dir.tmpdir) + SecureRandom.uuid }
      let(:tmp_string) { Faker::Lorem.sentence }
      before { Spirit.initialize_logger tmp_file }
      after  { tmp_file.unlink }

      it 'sets the log output' do
        Spirit.logger.info tmp_string
        File.read(tmp_file).should match(/#{tmp_string}/)
      end

    end

  end

end

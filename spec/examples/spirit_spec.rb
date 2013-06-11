require 'spec_helper'

describe Spirit do

  it { should respond_to :logger }

  describe '::reset_logger' do
    let(:file)   { Tempfile.new('out') }
    let(:string) { Faker::Lorem.sentence }
    before { Spirit.reset_logger file }
    after  { file.close; file.unlink }
    it 'sets the log output' do
      Spirit.logger.info string
      file.rewind
      file.read.should match(/#{string}/)
    end
  end

end

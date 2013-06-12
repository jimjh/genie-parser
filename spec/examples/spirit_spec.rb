require 'spec_helper'

describe Spirit do

  it { should respond_to :logger }

  describe '::reset_logger' do
    let(:file)   { Tempfile.new('out') }
    let(:string) { Faker::Lorem.sentence }
    before { Spirit.reset_logger file }
    after  { file.close; file.unlink; Spirit.reset_logger '/dev/null' }
    it 'sets the log output' do
      Spirit.logger.info string
      Spirit.logger.close
      file.open
      file.read.should match(/#{string}/)
    end
  end

end

require 'spec_helper'
require 'savon/mock/spec_helper'

module BrregGrunndata
  describe Client do
    describe 'unit tests' do
      let(:credentials) { { userid: 'test', password: 'secret' } }
      let(:config) { Configuration.new credentials }
      let(:service) { double 'savon' }

      subject do
        described_class.new configuration: config, service: service
      end

      describe 'hent_basisdata_mini' do
        it 'calls service with hent_basisdata_mini with expected message' do
          expect(service).to receive(:call)
            .with(:hent_basisdata_mini, message: credentials.merge(orgnr: '123'))

          subject.hent_basisdata_mini orgnr: '123'
        end
      end
    end
  end
end

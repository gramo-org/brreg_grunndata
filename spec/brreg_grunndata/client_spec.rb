require 'spec_helper'

module BrregGrunndata
  describe Client do
    describe 'unit tests' do
      let(:credentials) { { username: 'test', password: 'secret' } }
      let(:config) { Configuration.new credentials }
      let(:service) { double 'savon' }

      subject do
        described_class.new configuration: config, service: service
      end

      describe 'hent_basisdata' do
        it 'calls service with hent_basisdata with expected message' do
          expect(service).to receive(:call)
            .with(:hent_basisdata, credentials.merge(orgnr: '123'))

          subject.hent_basisdata orgnr: '123'
        end
      end
    end

    describe 'integration tests' do
      shared_examples 'common client failures' do
        it 'fails when status is -1, with no substatus'
        it 'fails when call was unauthenticated, status -1, substatus 101'
      end

      describe 'hent_basisdata' do
        include_examples 'common client failures'
      end
    end
  end
end

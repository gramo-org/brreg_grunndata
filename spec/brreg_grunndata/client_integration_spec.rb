# rubocop:disable Metrics/BlockLength

require 'spec_helper'
require 'savon/mock/spec_helper'

module BrregGrunndata
  describe Client do
    describe 'integration tests' do
      include Savon::SpecHelper

      let(:credentials) { { userid: 'test', password: 'secret' } }
      let(:config) { Configuration.new credentials }

      subject do
        described_class.new configuration: config
      end

      shared_examples 'common client successes' do
        it 'is a success' do
          pending

          expect(subject.public_send(operation, message))
            .to be_a_success
        end

        it 'returns a response of expected type' do
          pending

          expect(subject.public_send(operation, message))
            .to be_a Response
        end
      end

      shared_examples 'common client failures' do
        it 'fails when status is -1, with no substatus'
        it 'fails when call was unauthenticated, status -1, substatus 101'
      end

      describe 'hent_basisdata_mini' do
        let(:operation) { 'hent_basisdata_mini' }
        let(:message) { { orgnr: '992090936' } }

        context 'success' do
          before(:all) { savon.mock!   }
          after(:all)  { savon.unmock! }

          include_examples 'common client successes', operation: :hent_basisdata_mini
        end

        include_examples 'common client failures'
      end
    end
  end
end

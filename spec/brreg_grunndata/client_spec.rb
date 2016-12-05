# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength

require 'spec_helper'
require 'savon/mock/spec_helper'

module BrregGrunndata
  describe Client do
    describe 'integration tests' do
      include Savon::SpecHelper

      before(:all) { savon.mock!   }
      after(:all)  { savon.unmock! }

      let(:credentials) { { userid: 'test', password: 'secret' } }
      let(:config) { Configuration.new credentials }

      subject do
        described_class.new configuration: config
      end

      shared_examples 'common client successes' do
        it 'is a success' do
          expect(subject.public_send(operation, message))
            .to be_a_success
        end

        it 'returns a response of expected type' do
          expect(subject.public_send(operation, message))
            .to be_a BrregGrunndata::Client::Response
        end
      end

      shared_examples 'common client failures' do
        it 'fails when status is -1, with no substatus' do
          savon
            .expects(:hent_basisdata_mini)
            .with(message: hash_including(message))
            .returns(read_fixture('fail_no_substatus'))

          expect { subject.public_send(operation, message) }
            .to raise_error Client::ResponseValidator::UnexpectedError
        end

        it 'fails when call was unauthenticated, status -1, substatus 101' do
          savon
            .expects(:hent_basisdata_mini)
            .with(message: hash_including(message))
            .returns(read_fixture('fail_authorization'))

          expect { subject.public_send(operation, message) }
            .to raise_error Client::ResponseValidator::UnauthorizedError
        end
      end

      describe '#sok_enhet' do
        let(:operation) { 'sok_enhet' }

        it 'makes correct request including CDATA, inner xml.'
      end

      describe '#hent_basisdata_mini' do
        let(:operation) { 'hent_basisdata_mini' }
        let(:message) { { orgnr: '992090936' } }

        context 'success' do
          before do
            savon
              .expects(:hent_basisdata_mini)
              .with(message: hash_including(message))
              .returns(read_fixture('hent_basisdata_mini_success'))
          end

          include_examples 'common client successes'

          it 'contains expected header with main_status and sub_statuses' do
            response = subject.hent_basisdata_mini(message)

            expect(response.header.main_status).to eq 0
            expect(response.header.sub_statuses).to eq [
              { code: 0, message: 'Data returnert' },
              { code: 1020, message: 'Enhet 992090936 har ikke postadresse' }
            ]
          end

          it 'contains expected message' do
            response = subject.hent_basisdata_mini(message)
            expect(response.message).to eq fixture_hent_basisdata_mini_hash
          end
        end

        context 'failures' do
          include_examples 'common client failures'
        end
      end
    end
  end
end

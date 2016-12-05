# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
# rubocop:disable Metrics/ModuleLength

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
            .expects(operation)
            .with(message: hash_including(message))
            .returns(read_fixture('fail_no_substatus'))

          expect { subject.public_send(operation, message) }
            .to raise_error Client::ResponseValidator::UnexpectedError
        end

        it 'fails when call was unauthenticated, status -1, substatus 101' do
          savon
            .expects(operation)
            .with(message: hash_including(message))
            .returns(read_fixture('fail_authorization'))

          expect { subject.public_send(operation, message) }
            .to raise_error Client::ResponseValidator::UnauthorizedError
        end

        it 'fails on timeout' do
          expect(subject)
            .to receive_message_chain(:service, :call)
            .and_raise ::Net::ReadTimeout

          expect { subject.public_send(operation, message) }
            .to raise_error Client::TimeoutError
        end
      end

      describe '#sok_enhet' do
        let(:operation) { :sok_enhet }
        let(:message) { { query: 'STATOIL ASA' } }

        # rubocop:disable Metrics/LineLength
        it 'makes correct request including CDATA, inner xml.' do
          expected = '<![CDATA[<BrAixXmlRequest RequestName="BrErfrSok"><BrErfrSok><BrSokeStreng>STATOIL ASA</BrSokeStreng><MaxTreffReturneres>100</MaxTreffReturneres><ReturnerIngenHvisMax>true</ReturnerIngenHvisMax><RequestingIPAddr>010.001.052.011</RequestingIPAddr><RequestingTjeneste>SOAP</RequestingTjeneste><MedUnderenheter>true</MedUnderenheter></BrErfrSok></BrAixXmlRequest>]]>'

          savon
            .expects(:sok_enhet)
            .with(message: hash_including(search_request!: expected))
            .returns(read_fixture('sok_enhet_statoil_success'))

          subject.sok_enhet query: 'STATOIL ASA'
        end
        # rubocop:enable Metrics/LineLength

        describe 'success' do
          before do
            savon
              .expects(:sok_enhet)
              .with(message: :any)
              .returns(read_fixture('sok_enhet_statoil_success'))
          end

          include_examples 'common client successes'

          it 'returns expected header' do
            response = subject.sok_enhet query: 'STATOIL ASA'

            expect(response.header.main_status).to eq 0
            expect(response.header.sub_statuses).to eq [
              { code: 0, message: 'Data returnert' }
            ]
          end

          it 'returns expected message' do
            response = subject.sok_enhet query: 'STATOIL ASA'

            expect(response.message.dig(
              :br_aix_xml_response, :br_erfr_treffliste, :br_erfr_treffliste_element
            ).length).to eq 61
          end
        end
      end

      describe '#hent_basisdata_mini' do
        let(:operation) { :hent_basisdata_mini }
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

      describe '#hent_kontaktdata' do
        let(:operation) { :hent_kontaktdata }
        let(:message) { { orgnr: '992090936' } }

        context 'success' do
          before do
            savon
              .expects(:hent_kontaktdata)
              .with(message: hash_including(message))
              .returns(read_fixture('hent_kontaktdata_success'))
          end

          include_examples 'common client successes'

          it 'contains expected header with main_status and sub_statuses' do
            response = subject.hent_kontaktdata(message)

            expect(response.header.main_status).to eq 0
            expect(response.header.sub_statuses).to eq [
              { code: 0,    message: 'Data returnert' },
              { code: 1115, message: 'Enhet 992090936 har ikke telefon' },
              { code: 1116, message: 'Enhet 992090936 har ikke telefaks' },
              { code: 1119, message: 'Enhet 992090936 har ikke hjemmeside' }
            ]
          end

          it 'contains expected message' do
            response = subject.hent_kontaktdata(message)
            expect(response.message).to eq fixture_hent_kontaktdata_hash
          end
        end

        context 'failures' do
          include_examples 'common client failures'
        end
      end
    end
  end
end

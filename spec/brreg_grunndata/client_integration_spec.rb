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
            .to be_a BrregGrunndata::Response
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
          before do
            savon
              .expects(:hent_basisdata_mini)
              .with(message: hash_including(message))
              .returns(read_fixture('success_hent_basisdata_mini'))
          end

          include_examples 'common client successes'

          it 'unwraps the response' do
            response = subject.hent_basisdata_mini(message)

            expect(response.unwrap[:grunndata][:melding]).to eq(
              {
                :organisasjonsnummer=>'992090936',
                :navn=>{:navn1=>'PETER SKEIDE CONSULTING', :@registrerings_dato=>'2007-12-19'},
                :forretnings_adresse=>{:adresse1=>'Bård Skolemesters vei 6', :postnr=>'0590',
                :poststed=>'OSLO', :kommunenummer=>'0301', :kommune=>'OSLO', :landkode=>'NOR',
                :land=>'Norge', :@registrerings_dato=>'2008-04-01'},
                :organisasjonsform=>{:orgform=>'ENK', :orgform_beskrivelse=>'Enkeltpersonforetak', :@registrerings_dato=>'2007-12-19'},
                :@tjeneste=>'hentBasisdataMini'
              }
            )
          end
        end

        include_examples 'common client failures'
      end
    end
  end
end

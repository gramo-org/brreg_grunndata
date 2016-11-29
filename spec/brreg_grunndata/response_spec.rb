require 'spec_helper'

module BrregGrunndata
  describe Response do
    let(:globals) { Savon::GlobalOptions.new }
    let(:locals) { {} }

    let(:http) do
      double  'http',
              body: raw_body,
              error?: false
    end

    let(:savon_response) { Savon::Response.new http, globals, locals }

    subject { described_class.new savon_response }

    describe '#header' do
      context 'success' do
        let(:raw_body) { read_fixture('success_hent_basisdata_mini') }

        it 'returns a ResponseHeader' do
          expect(subject.header).to be_a ResponseHeader
        end

        it 'indicates success' do
          expect(subject.header).to be_success
        end

        it 'has a main_status' do
          expect(subject.header.main_status).to eq 0
        end

        it 'has expected sub_statuses' do
          expect(subject.header.sub_statuses).to eq [
            { code: 0, message: 'Data returnert' },
            { code: 1020, message: 'Enhet 992090936 har ikke postadresse' }
          ]
        end
      end

      context 'failure' do
        let(:raw_body) { read_fixture('fail_authorization') }
      end
    end

    describe '#message' do
      context 'success' do
        let(:raw_body) { read_fixture('success_hent_basisdata_mini') }

        it 'returns expected message as hash' do
          expect(subject.message[:organisasjonsnummer]).to eq '992090936'
          expect(subject.message[:organisasjonsform][:orgform]).to eq 'ENK'
        end
      end

      context 'failure' do
        let(:raw_body) { read_fixture('fail_authorization') }

        it 'has empty message' do
          expect { subject.message }
            .to raise_error Response::ResponseFailureError
        end

        it 'fails when soap was no success' do
          expect(savon_response).to receive(:success?).and_return false

          expect { subject.message }
            .to raise_error Response::ResponseFailureError
        end
      end
    end
  end
end

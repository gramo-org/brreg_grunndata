# frozen_string_literal: true

require 'spec_helper'

module BrregGrunndata
  # rubocop:disable Metrics/BlockLength
  describe Service do
    let(:empty_response) do
      instance_double(Client::Response).tap do |r|
        allow(r).to receive(:message).and_raise Client::Response::MessageEmptyError
      end
    end

    let(:client) { instance_double Client }

    subject { described_class.new client: client }

    describe '#hent_basisdata_mini' do
      context 'found' do
        let(:filled_response) do
          instance_double Client::Response,
                          message: fixture_hent_basisdata_mini_hash(orgnr: '923609016')
        end

        before do
          expect(client).to receive(:hent_basisdata_mini).and_return filled_response
        end

        it 'returns an organization with expected data' do
          organization = subject.hent_basisdata_mini orgnr: '992090936'

          expect(organization).to be_a Types::Organization

          expect(organization.orgnr).to eq 923_609_016
          expect(organization.name).to eq 'STATOIL ASA'
          expect(organization.business_address.street).to eq 'Forusbeen 50'
          expect(organization.business_address.municipality).to eq 'STAVANGER'
          expect(organization.postal_address.street).to eq 'Postboks 8500'
          expect(organization.postal_address.municipality_number).to eq '1103'
          expect(organization.organizational_form.name).to eq 'ASA'
        end
      end

      context 'not found' do
        before do
          expect(client).to receive(:hent_basisdata_mini).and_return empty_response
        end

        it 'returns null when not found' do
          organization = subject.hent_basisdata_mini orgnr: '123456789'
          expect(organization).to be_nil
        end
      end
    end

    describe '#hent_kontaktdata' do
      context 'found' do
        let(:filled_response) do
          instance_double Client::Response,
                          message: fixture_hent_kontaktdata_hash(orgnr: '923609016')
        end

        before do
          expect(client).to receive(:hent_kontaktdata).and_return filled_response
        end

        it 'returns an organization with expected data' do
          organization = subject.hent_kontaktdata orgnr: '992090936'

          expect(organization).to be_a Types::Organization

          expect(organization.orgnr).to eq 923_609_016
          expect(organization.name).to eq nil
          expect(organization.telephone_number).to eq '51 99 00 00'
          expect(organization.telefax_number).to eq '51 99 00 50'
          expect(organization.mobile_number).to eq nil
        end
      end

      context 'not found' do
        before do
          expect(client).to receive(:hent_kontaktdata).and_return empty_response
        end

        it 'returns null when not found' do
          organization = subject.hent_kontaktdata orgnr: '123456789'
          expect(organization).to be_nil
        end
      end
    end
  end
end

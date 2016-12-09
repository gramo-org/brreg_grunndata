# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
# rubocop:disable Metrics/ModuleLength
require 'spec_helper'

module BrregGrunndata
  describe Service do
    let(:empty_response) do
      instance_double(Client::Response).tap do |r|
        allow(r).to receive(:message).and_raise Client::Response::MessageEmptyError
      end
    end

    let(:filled_basisdata_response) do
      instance_double Client::Response,
                      message: fixture_hent_basisdata_mini_hash(orgnr: '923609016')
    end

    let(:filled_kontaktdata_response) do
      instance_double Client::Response,
                      message: fixture_hent_kontaktdata_hash(orgnr: '923609016')
    end

    let(:filled_saerlige_opplysninger_response) do
      instance_double Client::Response,
                      message: fixture_hent_saerlige_opplysninger_hash(orgnr: '923609016')
    end

    let(:client) { instance_double Client }

    subject { described_class.new client: client }

    describe '#hent_basisdata_mini' do
      context 'found' do
        context 'statoil' do
          before do
            expect(client).to receive(:hent_basisdata_mini).and_return filled_basisdata_response
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

        context 'Skalar AS' do
          before do
            expect(client).to receive(:hent_basisdata_mini)
              .and_return(
                instance_double(
                  Client::Response, message: fixture_hent_basisdata_mini_hash(orgnr: '991025022')
                )
              )
          end

          it 'returns an organization with expected data' do
            organization = subject.hent_basisdata_mini orgnr: '991025022'

            expect(organization).to be_a Types::Organization

            expect(organization.orgnr).to eq 991_025_022
            expect(organization.name).to eq 'SKALAR AS'
            expect(organization.business_address.street_parts).to eq [
              '4. etasje', 'Kongens gate 11'
            ]
            expect(organization.business_address.street).to eq '4. etasje, Kongens gate 11'
          end
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
        before do
          expect(client).to receive(:hent_kontaktdata).and_return filled_kontaktdata_response
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

    describe '#hent_saerlige_opplysninger' do
      context 'found' do
        before do
          expect(client).to receive(:hent_saerlige_opplysninger)
            .and_return filled_saerlige_opplysninger_response
        end

        it 'returns an organization with expected data' do
          organization = subject.hent_saerlige_opplysninger orgnr: '992090936'

          expect(organization).to be_a Types::Organization
          expect(organization.orgnr).to eq 923_609_016

          info = organization.additional_information[0]
          expect(info).to be_a Types::AdditionalInformation

          expect(info.registered_date).to eq Date.new(1988, 4, 28)
          expect(info.status_code).to eq 'R-FR'
          expect(info.description).to eq 'Registrert i Foretaksregisteret'
        end
      end

      context 'not found' do
        before do
          expect(client).to receive(:hent_saerlige_opplysninger).and_return empty_response
        end

        it 'returns null when not found' do
          organization = subject.hent_saerlige_opplysninger orgnr: '123456789'
          expect(organization).to be_nil
        end
      end
    end

    describe '#run_concurrently' do
      let(:operations) { [:hent_basisdata_mini, :hent_kontaktdata] }

      context 'found' do
        before do
          expect(client).to receive(:hent_basisdata_mini).and_return filled_basisdata_response
          expect(client).to receive(:hent_kontaktdata).and_return filled_kontaktdata_response
        end

        it 'returns an organization with expected data' do
          organization = subject.run_concurrently operations, orgnr: '923609016'

          expect(organization).to be_a Types::Organization

          expect(organization.orgnr).to eq 923_609_016
          expect(organization.name).to eq 'STATOIL ASA'
          expect(organization.business_address.street).to eq 'Forusbeen 50'
          expect(organization.business_address.municipality).to eq 'STAVANGER'
          expect(organization.postal_address.street).to eq 'Postboks 8500'
          expect(organization.postal_address.municipality_number).to eq '1103'
          expect(organization.organizational_form.name).to eq 'ASA'
          expect(organization.telephone_number).to eq '51 99 00 00'
          expect(organization.telefax_number).to eq '51 99 00 50'
        end

        context 'with postal address empty' do
          let(:filled_basisdata_response) do
            instance_double Client::Response,
                            message: fixture_hent_basisdata_mini_hash(orgnr: '992090936')
          end

          let(:filled_kontaktdata_response) do
            instance_double Client::Response,
                            message: fixture_hent_kontaktdata_hash(orgnr: '992090936')
          end

          it 'returns an organization where postal address is nil' do
            organization = subject.run_concurrently operations, orgnr: '992090936'

            expect(organization).to be_a Types::Organization

            expect(organization.business_address.street).to eq 'Bård Skolemesters vei 6'
            expect(organization.postal_address).to be_nil
          end
        end
      end

      context 'not found' do
        before do
          expect(client).to receive(:hent_basisdata_mini).and_return empty_response
          expect(client).to receive(:hent_kontaktdata).and_return empty_response
        end

        it 'returns null when not found' do
          organization = subject.run_concurrently operations, orgnr: '123456789'
          expect(organization).to be_nil
        end
      end

      context 'partially error' do
        before do
          expect(client).to receive(:hent_basisdata_mini).and_return filled_basisdata_response
          expect(client).to receive(:hent_kontaktdata).and_raise Client::TimeoutError
        end

        it 'raises the error' do
          expect { subject.run_concurrently operations, orgnr: '123456789' }
            .to raise_error Client::TimeoutError
        end
      end

      context 'operation does not exist' do
        it 'raises error' do
          expect { subject.run_concurrently [:boom], orgnr: '123456789' }
            .to raise_error Utils::ConcurrentOperations::UnkownOperationError
        end
      end
    end
  end
end

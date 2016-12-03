# frozen_string_literal: true

require 'spec_helper'

module BrregGrunndata
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
        it 'returns an organization with expected data'
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
  end
end

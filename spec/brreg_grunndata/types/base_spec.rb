# frozen_string_literal: true

require 'spec_helper'

module BrregGrunndata
  # rubocop:disable Metrics/BlockLength
  describe Types::Base do
    class TestAddr < described_class
      attribute :street,      Types::String
      attribute :postal_code, Types::String
    end

    class TestOrg < described_class
      attribute :orgnr,               Types::Coercible::Integer
      attribute :name,                Types::String.optional
      attribute :business_address,    TestAddr.optional
      attribute :postal_address,      TestAddr.optional
    end

    subject do
      TestOrg.new orgnr: 123_456_789,
                  name: 'Big',
                  business_address: {
                    street: 'Askerveien',
                    postal_code: '1384'
                  }
    end

    describe '#merge' do
      it 'fails when it is asked to be merged with other type' do
        expect { subject.merge TestAddr.new }.to raise_error ArgumentError
      end

      it 'does not modify original object' do
        expect { subject.merge TestOrg.new postal_address: { street: 'Foo' } }
          .to_not change(subject, :postal_address).from nil
      end

      it 'returns an object where its root attributes are updated' do
        merged = subject.merge TestOrg.new postal_address: { street: 'Foo' }
        expect(merged.name).to eq 'Big'
        expect(merged.postal_address).to eq TestAddr.new street: 'Foo'
      end
    end
  end
end

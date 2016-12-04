# frozen_string_literal: true

require 'spec_helper'

module BrregGrunndata
  describe Types::Organization do
    subject do
      described_class.new(
        orgnr: 123_456_789,
        name: nil,
        business_address: {
          street: 'Askerveien 1'
        },
        postal_address: nil,
        organizational_form: nil
      )
    end
  end
end

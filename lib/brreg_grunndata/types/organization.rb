# frozen_string_literal: true

require_relative 'base'
require_relative 'address'
require_relative 'organizational_form'
require_relative 'additional_information'

module BrregGrunndata
  module Types
    class Organization < Base
      attribute :orgnr,               Types::Coercible::Integer
      attribute :organizational_form, Types::OrganizationalForm.optional.default(nil)

      attribute :name,                Types::String.optional.default(nil)

      attribute :telephone_number,    Types::String.optional.default(nil)
      attribute :telefax_number,      Types::String.optional.default(nil)
      attribute :mobile_number,       Types::String.optional.default(nil)
      attribute :email,               Types::String.optional.default(nil)
      attribute :web_page,            Types::String.optional.default(nil)

      attribute :business_address,    Types::Address.optional.default(nil)
      attribute :postal_address,      Types::Address.optional.default(nil)

      attribute :additional_information, Types::Strict::Array
        .of(Types::AdditionalInformation)
        .default { [] }
    end
  end
end

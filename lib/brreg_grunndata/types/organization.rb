# frozen_string_literal: true

require_relative 'base'
require_relative 'address'
require_relative 'organizational_form'
require_relative 'additional_information'

module BrregGrunndata
  module Types
    class Organization < Base
      attribute :orgnr,               Types::Coercible::Int
      attribute :organizational_form, Types::OrganizationalForm.optional

      attribute :name,                Types::String.optional

      attribute :telephone_number,    Types::String.optional
      attribute :telefax_number,      Types::String.optional
      attribute :mobile_number,       Types::String.optional
      attribute :email,               Types::String.optional
      attribute :web_page,            Types::String.optional

      attribute :business_address,    Types::Address.optional
      attribute :postal_address,      Types::Address.optional

      attribute :additional_information, Types::Strict::Array
        .member(Types::AdditionalInformation)
        .default([])
    end
  end
end

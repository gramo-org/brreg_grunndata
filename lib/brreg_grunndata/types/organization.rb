# frozen_string_literal: true

require_relative 'base'
require_relative 'address'
require_relative 'organizational_form'

module BrregGrunndata
  module Types
    class Organization < Base
      attribute :orgnr,               Types::Coercible::Int
      attribute :name,                Types::String
      attribute :business_address,    Types::Address
      attribute :postal_address,      Types::Address
      attribute :organizational_form, Types::OrganizationalForm
    end
  end
end

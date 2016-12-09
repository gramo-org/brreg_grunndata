# frozen_string_literal: true

require_relative 'base'

module BrregGrunndata
  module Types
    class Address < Base
      attribute :street_parts,        Types::Array.member(Types::String).default([])
      attribute :postal_code,         Types::String
      attribute :postal_area,         Types::String
      attribute :municipality_number, Types::String
      attribute :municipality,        Types::String
      attribute :country_code,        Types::String
      attribute :country,             Types::String

      # Returns this address' street
      #
      # Brreg returns street as three parts. You find them in #street_parts.
      # If you just one a string representing the street this is your method.
      # It joins the parts by given separator defaulting to ', '
      #
      # @return String
      def street(separator = ', ')
        street_parts.join separator
      end
    end
  end
end

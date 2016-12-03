# frozen_string_literal: true

require_relative 'base'

module BrregGrunndata
  module Types
    class Address < Base
      attribute :street,              Types::String
      attribute :postal_code,         Types::String
      attribute :postal_area,         Types::String
      attribute :municipality_number, Types::String
      attribute :municipality,        Types::String
      attribute :country_code,        Types::String
      attribute :country,             Types::String
    end
  end
end

# frozen_string_literal: true

require_relative 'base'

module BrregGrunndata
  module Types
    class OrganizationalForm < Base
      attribute :name,        Types::String
      attribute :description, Types::String
    end
  end
end

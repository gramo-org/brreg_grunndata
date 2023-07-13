# frozen_string_literal: true

require_relative 'base'

module BrregGrunndata
  module Types
    # Additional information represents data we get from
    # the hent_saerlige_opplysninger soap operation.
    #
    # It contains status code, a Norwegian description and date for when
    # this information was registered.
    class AdditionalInformation < Base
      attribute :status_code,     Types::String
      attribute :description,     Types::String | Types::Array.of(Types::String)
      attribute :registered_date, Types::Params::Date.optional.default(nil)
    end
  end
end

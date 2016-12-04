# frozen_string_literal: true

require_relative 'types/factories'
require_relative 'utils'

module BrregGrunndata
  # The service returns ruby objects with data fetched from API
  #
  # This interface has a higher abstraction than working directly
  # with the Client, where the object you get back has coerced values
  # instead of working with a hash of strings.
  #
  # @see Client
  class Service
    attr_reader :client

    def initialize(client:)
      @client = client
    end

    # Runs given operations concurrently
    #
    # Arguments
    #   operations    -   An array of operations to run concurrently
    #                     The named operations must be defined as
    #                     methods on the service and they must return same type.
    #   args          -   All other arguments are passed on to each operations.
    def run_concurrently(operations, **args)
      results = Utils::ConcurrentOperations.new(self, operations, args).call

      return nil if results.any?(&:nil?)

      results.reduce { |acc, elem| acc.merge elem }
    end

    # Get basic mini data of an organization
    #
    # Arguments
    #   orgnr   - The orgnr you are searching for
    #
    # @return BrregGrunndata::Types::Organization
    def hent_basisdata_mini(orgnr:)
      Types::FromResponseFactory.organization client.hent_basisdata_mini orgnr: orgnr
    end

    # Get contact information for an organization
    #
    # Arguments
    #   orgnr   - The orgnr you are searching for
    #
    # @return BrregGrunndata::Types::Organization
    def hent_kontaktdata(orgnr:)
      Types::FromResponseFactory.organization client.hent_kontaktdata orgnr: orgnr
    end
  end
end

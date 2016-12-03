# frozen_string_literal: true

require_relative 'types/organization'

module BrregGrunndata
  # The service returns ruby objects with data fetched from API
  #
  # This interface has a higher abstraction than working directly
  # with the Client.
  #
  # @see Client
  class Service
    attr_reader :client

    def initialize(client:)
      @client = client
    end

    # Get basic mini data of an organization
    #
    # Attributes
    #   orgnr   - The orgnr you are searching for
    #
    # @return BrregGrunndata::Types::Organization
    def hent_basisdata_mini(orgnr:)
      Types::Organization.from_response client.hent_basisdata_mini orgnr: orgnr
    rescue Client::Response::MessageEmptyError
      nil
    end
  end
end

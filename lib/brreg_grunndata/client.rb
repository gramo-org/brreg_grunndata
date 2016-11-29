require 'savon'

require_relative 'response'
require_relative 'response_validator'

module BrregGrunndata
  # Brreg client to access brreg's data
  #
  # This is a thin wrapper around BRREG's soap API using
  # Savon to communicate.
  #
  # Compared to simply use savon directly use of this client offers:
  #   - Unwrap the return value (which is a XML string)
  #   - Handle common errors
  #   - Has a clear interface of the soap operations we support.
  class Client
    # Build a client with given user id and password, or read credentials from ENV.
    # Mostly used for development for easy access to a usable client.
    def self.build(userid: nil, password: nil, debug: false)
      config = {
        userid: userid || ENV['BRREG_USERNAME'],
        password: password || ENV['BRREG_PASSWORD']
      }

      if debug
        config[:logger] = Logger.new(STDOUT)
        config[:log_level] = :debug
      end

      new configuration: Configuration.new(config)
    end

    def initialize(configuration:, service: nil)
      @configuration = configuration
      @service = service || build_savon_service
    end

    # Get basic mini data of an organization
    #
    # Attributes
    #   orgnr   - The orgnr you are searching for
    #
    # @return BrregGrunndata::Response
    def hent_basisdata_mini(orgnr:)
      call :hent_basisdata_mini, orgnr: orgnr
    end

    # Get contact information for an organization
    #
    # Attributes
    #   orgnr   - The orgnr you are searching for
    #
    # @return BrregGrunndata::Response
    def hent_kontaktdata(orgnr:)
      call :hent_kontaktdata, orgnr: orgnr
    end

    # Search for an organization
    #
    # Makes it possible to find an organization from name
    #
    # Attributes
    #   query   - Your query as a string
    #
    # @return BrregGrunndata::Response
    def sok_enhet(query:)
      call :sok_enhet, search_request: query
    end

    # Gets extended information about an organization
    #
    # This returns information regarding organization is
    # "Foretaksregisteret", "Merverdiavgiftsregisteret", or "konkursbehandling"
    #
    # Attributes
    #   orgnr   - The orgnr you are searching for
    #
    # @return BrregGrunndata::Response
    def hent_saerlige_opplysninger(orgnr:)
      call :hent_saerlige_opplysninger, orgnr: orgnr
    end

    # Gets information from "Tilknyttet registeret"
    #
    # Contains information about "naeringskode", "sektorkode", "ansvarskapital"
    # and number of employees
    #
    # Attributes
    #   orgnr   - The orgnr you are searching for
    #
    # @return BrregGrunndata::Response
    def hent_opplysninger_tilknyttet_register(orgnr:)
      call :hent_oppl_tilkn_register, orgnr: orgnr
    end

    private

    attr_reader :configuration, :service

    # Calls the operation in soap service. Message will include credentials
    #
    # Arguments
    #   operation   - The name of the operation, ex :hent_basisdata_mini
    #   message     - The message to be sent to the operation.
    #                 Credentials will be merged before message is sent.
    def call(operation, message)
      savon_response = service.call operation, message: message.merge(credentials)

      ResponseValidator.new(
        Response.new(savon_response)
      ).raise_error_or_return_response!
    end

    def build_savon_service
      options = {
        wsdl: configuration.wsdl
      }

      if configuration.logger
        options[:logger] = configuration.logger
        options[:log_level] = configuration.log_level
        options[:log] = true
      end

      Savon.client options
    end

    def credentials
      {
        userid: configuration.userid,
        password: configuration.password
      }
    end
  end
end

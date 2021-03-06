# frozen_string_literal: true

require 'savon'

require_relative 'client/response'
require_relative 'client/response_validator'
require_relative 'client/sok_enhet_query_to_xml'

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
  #
  # @see Service
  class Client
    # Raised when we have a timeout error
    class TimeoutError < Error; end

    def initialize(configuration:, service: nil)
      @configuration = configuration
      @service = service || build_savon_service
    end

    # Get basic mini data of an organization
    #
    # Arguments
    #   orgnr   - The orgnr you are searching for
    #
    # @return BrregGrunndata::Response
    def hent_basisdata_mini(orgnr:)
      call :hent_basisdata_mini, orgnr: orgnr
    end

    # Get contact information for an organization
    #
    # Arguments
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
    # NOTE
    # ==================
    # The response.message you get back seems to be a document of it's own,
    # with header, some info about the search, and the hits.
    #
    # We may choose to do something with this message response in the
    # future, or make this easier to use on the service level.
    #
    # Currently its structure is something like:
    #
    # <BrAixXmlResponse ResponseType="BrErfrTreffliste">
    #   <BrAixResponseHeader>
    #     <ReturStatus>0</ReturStatus>
    #     <TimeStamp>2016-12-04T20:03:09</TimeStamp>
    #     <ElapsedTime>168</ElapsedTime>
    #     <AntallTreff>61</AntallTreff>
    #   </BrAixResponseHeader>
    #   <Sokeverdier>
    #     <BrSokeStreng>STATOIL ASA</BrSokeStreng>
    #     <OrgForm>ALLE</OrgForm>
    #     <Fylke Fylkesnr="0">ALLE</Fylke>
    #     <Kommune Kommunenr="0">ALLE</Kommune>
    #     <Slettet>N</Slettet>
    #     <MedUnderenheter>true</MedUnderenheter>
    #     <MaxTreffReturneres>100</MaxTreffReturneres>
    #     <ReturnerIngenHvisMax>true</ReturnerIngenHvisMax>
    #   </Sokeverdier>
    #   <BrErfrTreffliste Antall="61">
    #     <BrErfrTrefflisteElement>
    #       <Orgnr>873152362</Orgnr>
    #       <OrgNavn>STATOIL ASA AVD KONTOR BERGEN</OrgNavn>
    #       <Sted>5254 SANDSLI</Sted>
    #       <Score>100</Score>
    #       <OrgForm>BEDR</OrgForm>
    #     </BrErfrTrefflisteElement>
    #
    # ...
    #
    #
    # Arguments
    #   query             -   Your search string / query goes here
    #   first             -   How many do you want to get in return? (the limit)
    #   include_no_if_max -   Do you want zero results if your search yields more
    #                         results than the first X you asked for? I don't know
    #                         why you would want that.
    #   with_subdivision  -   Do you want to include organization form BEDR og AAFY
    #                         when you search?
    # @return BrregGrunndata::Response
    def sok_enhet(query:, first: 100, include_no_if_max: false, with_subdivision: true)
      call :sok_enhet, search_request!: SokEnhetQueryToXml.new(
        query,
        first: first,
        include_no_if_max: include_no_if_max,
        with_subdivision: with_subdivision
      ).cdata
    end

    # Gets extended information about an organization
    #
    # This returns information regarding organization is
    # "Foretaksregisteret", "Merverdiavgiftsregisteret", or "konkursbehandling"
    #
    # Arguments
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
    # Arguments
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
    rescue ::Net::ReadTimeout
      raise TimeoutError
    end

    # rubocop:disable Metrics/MethodLength
    def build_savon_service
      options = {
        open_timeout: configuration.open_timeout,
        read_timeout: configuration.read_timeout,
        wsdl: configuration.wsdl
      }

      if configuration.logger
        options[:logger] = configuration.logger
        options[:log_level] = configuration.log_level
        options[:log] = true
      end

      Savon.client options
    end
    # rubocop:enable Metrics/MethodLength

    def credentials
      {
        userid: configuration.userid,
        password: configuration.password
      }
    end
  end
end

# frozen_string_literal: true

require 'builder'

module BrregGrunndata
  # Translate a simple query string to an XML document to search with sok_enhet operation
  #
  # Given the query "STATOIL" the final XML to be put in soap search_request
  # will be:
  #
  # <![CDATA[
  #   <?xml version="1.0"?>
  #   <BrAixXmlRequest RequestName="BrErfrSok">
  #     <BrErfrSok>
  #       <BrSokeStreng>STATOIL</BrSokeStreng>
  #       <MaxTreffReturneres>1000</MaxTreffReturneres>
  #       <ReturnerIngenHvisMax>true</ReturnerIngenHvisMax>
  #       <RequestingIPAddr>010.001.052.011</RequestingIPAddr>
  #       <RequestingTjeneste>SOAP</RequestingTjeneste>
  #       <MedUnderenheter>true</MedUnderenheter>
  #     </BrErfrSok>
  #   </BrAixXmlRequest>
  # ]]
  #
  # Which is great: Now we got a  XML inside XML
  # payload instead of something simple ;-)
  #
  # Attributes
  #
  #   query             -   Your search string / query goes here
  #   first             -   How many do you want to get in return? (the limit)
  #   include_no_if_max -   Do you want zero results if your search yields more
  #                         results than the first X you asked for? I don't know
  #                         why you would want that.
  #   with_subdivision  -   Do you want to include organization form BEDR og AAFY
  #                         when you search?
  #   ip                -   Your client's IP. Seems to work with everything, as
  #                         long as you have xxx.xxx.xxx.xxx where x is [0-9].
  class SokEnhetQueryToXml
    def initialize(query,
                   first: 100,
                   include_no_if_max: false,
                   with_subdivision: true,
                   ip: '010.001.052.011')
      @query = query
      @first = first
      @ip = ip
      @include_no_if_max = include_no_if_max
      @with_subdivision = with_subdivision
    end

    def cdata
      "<![CDATA[#{xml}]]>"
    end

    private

    # rubocop:disable Metrics/MethodLength
    def xml
      data = {
        br_aix_xml_request: {
          :@RequestName => 'BrErfrSok',
          br_erfr_sok: {
            br_soke_streng: @query,
            max_treff_returneres: @first,
            returner_ingen_hvis_max: true,
            requesting_IP_addr: @ip,
            requesting_tjeneste: 'SOAP',
            med_underenheter: @with_subdivision
          }
        }
      }

      options = { key_converter: :camelcase }

      Gyoku.xml data, options
    end
    # rubocop:enable Metrics/MethodLength
  end
end

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
  class SokEnhetQueryToXml
    def initialize(query, first: 100, ip: '010.001.052.011')
      @query = query
      @first = first
      @ip = ip
    end

    def cdata
      "<![CDATA[#{xml}]]>"
    end

    private

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
            med_underenheter: true
          }
        }
      }

      options = { key_converter: :camelcase }

      Gyoku.xml data, options
    end
  end
end

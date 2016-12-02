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
    def initialize(query, first: 100)
      @query = query
      @first = first
    end

    def cdata
      <<~XML
        <![CDATA[
          <?xml version="1.0"?>
          <BrAixXmlRequest RequestName="BrErfrSok">
            <BrErfrSok>
              <BrSokeStreng>#{@query}</BrSokeStreng>
              <MaxTreffReturneres>#{@first}</MaxTreffReturneres>
              <ReturnerIngenHvisMax>true</ReturnerIngenHvisMax>
              <RequestingIPAddr>010.001.052.011</RequestingIPAddr>
              <RequestingTjeneste>SOAP</RequestingTjeneste>
              <MedUnderenheter>true</MedUnderenheter>
            </BrErfrSok>
          </BrAixXmlRequest>
        ]]>
      XML
    end
  end
end

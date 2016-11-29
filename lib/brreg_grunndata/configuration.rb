module BrregGrunndata
  # Contains configuration for the web service client
  class Configuration
    WSDL = 'https://ws.brreg.no/grunndata/ErFr?WSDL'.freeze

    attr_reader :userid, :password, :wsdl

    def initialize(userid:, password:, wsdl: WSDL)
      @userid = userid
      @password = password
      @wsdl = wsdl
    end
  end
end

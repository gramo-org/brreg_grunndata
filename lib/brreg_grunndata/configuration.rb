module BrregGrunndata
  # Contains configuration for the web service client
  class Configuration
    WSDL = 'https://ws.brreg.no/grunndata/ErFr?WSDL'.freeze

    attr_reader :username, :password, :wsdl

    def initialize(username:, password:, wsdl: WSDL)
      @username = username
      @password = password
      @wsdl = wsdl
    end
  end
end

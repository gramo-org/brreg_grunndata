module BrregGrunndata
  # Contains configuration for the web service client
  class Configuration
    WSDL = 'https://ws.brreg.no/grunndata/ErFr?WSDL'.freeze

    attr_reader :userid, :password, :logger, :log_level, :wsdl

    def initialize(userid:, password:, logger: nil, log_level: :info, wsdl: WSDL)
      @userid = userid
      @password = password
      @logger = logger
      @log_level = log_level
      @wsdl = wsdl
    end
  end
end

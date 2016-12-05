# frozen_string_literal: true

module BrregGrunndata
  # Contains configuration for the web service client
  class Configuration
    # WSDL is located at this URL
    WSDL_URL = 'https://ws.brreg.no/grunndata/ErFr?WSDL'

    # We have a saved WSDL at this location on disk
    WSDL_PATH = "#{__dir__}/wsdl/grunndata.xml"

    attr_reader :userid, :password,
                :open_timeout, :read_timeout,
                :logger, :log_level,
                :wsdl

    # rubocop:disable Metrics/ParameterLists
    def initialize(
      userid:,
      password:,
      open_timeout: 2,
      read_timeout: 2,
      logger: nil,
      log_level: :info,
      wsdl: WSDL_PATH
    )
      @userid = userid
      @password = password
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @logger = logger
      @log_level = log_level
      @wsdl = wsdl
    end
    # rubocop:enable Metrics/ParameterLists
  end
end

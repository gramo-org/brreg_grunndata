require 'savon'
require_relative 'response'

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

    def hent_basisdata_mini(orgnr:)
      Response.new call(:hent_basisdata_mini, orgnr: orgnr)
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
      service.call operation, message: message.merge(credentials)
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

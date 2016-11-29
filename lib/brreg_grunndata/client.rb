module BrregGrunndata
  class Client
    def self.build(username: nil, password: nil)
      new configuration: Configuration.new(
        username: username || ENV['BRREG_USERNAME'],
        password: password || ENV['BRREG_PASSWORD']
      )
    end

    def initialize(configuration:, service: nil)
      @configuration = configuration
      @service = service || build_savon_service
    end

    def hent_basisdata(orgnr:)
      call :hent_basisdata, orgnr: orgnr
    end

    private

    attr_reader :configuration, :service

    def call(action, message)
      service.call action, message.merge(credentials)
    end

    def build_savon_service
      Savon.client wsdl: configuration.wsdl
    end

    def credentials
      {
        username: configuration.username,
        password: configuration.password
      }
    end
  end
end

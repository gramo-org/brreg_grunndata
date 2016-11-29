module BrregGrunndata
  class Client
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

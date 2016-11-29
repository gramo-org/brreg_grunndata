module BrregGrunndata
  class Client
    def self.build(userid: nil, password: nil)
      new configuration: Configuration.new(
        userid: userid || ENV['BRREG_USERNAME'],
        password: password || ENV['BRREG_PASSWORD']
      )
    end

    def initialize(configuration:, service: nil)
      @configuration = configuration
      @service = service || build_savon_service
    end

    def hent_basisdata_mini(orgnr:)
      call :hent_basisdata_mini, orgnr: orgnr
    end

    private

    attr_reader :configuration, :service

    def call(action, message)
      service.call action, message: message.merge(credentials)
    end

    def build_savon_service
      Savon.client wsdl: configuration.wsdl
    end

    def credentials
      {
        userid: configuration.userid,
        password: configuration.password
      }
    end
  end
end

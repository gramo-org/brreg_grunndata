require 'forwardable'

require_relative 'utils'
require_relative 'response_header'

module BrregGrunndata
  # Wrapper around Savon's response
  #
  # Handles unwrapping of XML returned as string
  class Response
    using Utils::StringExt

    extend Forwardable
    def_delegators :@savon_response,
                   :soap_fault?, :http_error?,
                   :body

    # Error raised whenever soap or http error occured so
    # the success? is false but you are still asking for
    # either header or message
    class ResponseFailureError < Error; end

    # Error raised when soap communication was a success,
    # brreg response header indicates success, but for some
    # reason we didn't get any return value as we expected
    #
    # Inspecting #header before calling #message will determin if this error
    # is to be expected.
    #
    # @seehttps://www.brreg.no/produkter-og-tjenester/bestille/tilgang-til-enhetsregisteret-via-web-services/teknisk-beskrivelse-web-services/grunndataws/
    class MessageEmptyError < Error; end

    def initialize(savon_response)
      @savon_response = savon_response
    end

    # Do we have a successful response?
    #
    # We do if:
    #   - We have no HTTP errors or SOAP faults. Savon handles this for us.
    #   - We have a response_header in the document returned from brreg
    #     which indicates success too. I don't know why BRREG needs this in
    #     addition to HTTP status codes and SOAP faults to communicate success
    #     or not :-(
    def success?
      @savon_response.success? && header.success?
    end

    # Returns the header from brreg's response
    #
    # The header contains the overall success of the SOAP operation.
    # The header is something brreg's SOAP API has, so all in all we have
    # http status, soap status and then this status located within the header :(
    def header
      raise ResponseFailureError unless @savon_response.success?

      ResponseHeader.new response_grunndata[:response_header]
    end

    # Returns the header from brreg's response
    #
    # Keys are symbolized.
    #
    # @return Hash
    def message
      raise ResponseFailureError unless success?

      @message ||= begin
        message = response_grunndata[:melding]

        if message.nil?
          raise MessageEmptyError
        end

        message
      end
    end

    private

    def response_grunndata
      @response_grunndata ||= parse(body.values.first[:return])[:grunndata]
    end

    def parse(xml)
      parser = Nori.new(
        strip_namespaces: true,
        advanced_typecasting: true,
        convert_tags_to: ->(tag) { tag.underscore.to_sym }
      )

      parser.parse xml
    end
  end
end

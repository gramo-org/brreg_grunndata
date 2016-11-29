require 'forwardable'

require_relative 'utils'

module BrregGrunndata
  # Wrapper around Savon's response
  #
  # Handles unwrapping of XML returned as string
  class Response
    using Utils::StringExt

    extend Forwardable
    def_delegators :@savon_response,
                   :success?, :soap_fault?, :http_error?,
                   :body, :to_hash

    class UnwrapError < Error; end

    def initialize(savon_response)
      @savon_response = savon_response
    end

    def unwrap
      raise UnwrapError unless success?

      return_xml = body.values.first[:return]
      parse(return_xml)
    end

    private

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

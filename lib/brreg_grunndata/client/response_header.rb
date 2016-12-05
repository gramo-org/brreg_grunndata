# frozen_string_literal: true

module BrregGrunndata
  class Client
    # Represents a response header from brreg
    #
    # A response header has a main status and sub statuses.
    #
    # MAIN STATUS:
    #   0   -   OK
    #   1   -   OK, but some data is missing. See sub status for details
    #  -1   -   An error as occured
    #
    # @see https://www.brreg.no/produkter-og-tjenester/bestille/tilgang-til-enhetsregisteret-via-web-services/teknisk-beskrivelse-web-services/grunndataws/
    class ResponseHeader
      MAIN_STATUS_SUCCESS_CODES = [0, 1].freeze

      def initialize(nori_response_header)
        @nori_response_header = nori_response_header
      end

      # Returns true if the brreg response header indicates success.
      def success?
        MAIN_STATUS_SUCCESS_CODES.include? main_status
      end

      def main_status
        @main_status ||= cast_to_int(@nori_response_header[:hoved_status])
      end

      def sub_statuses
        return [] unless @nori_response_header.key? :under_status

        statuses = Array(@nori_response_header[:under_status][:under_status_melding])

        @sub_statuses ||= statuses.map do |status|
          {
            code: cast_to_int(status.attributes['kode']),
            message: status.to_s
          }
        end
      end

      # rubocop:disable Style/LineEndConcatenation
      def inspect
        "#<BrregGrunndata::ResponseHeader: main_status: #{main_status} " +
          "sub_statuses: #{sub_statuses}>"
      end
      # rubocop:enable Style/LineEndConcatenation

      private

      def cast_to_int(v)
        Integer v, 10
      end
    end
  end
end

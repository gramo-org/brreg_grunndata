module BrregGrunndata
  class ResponseValidator
    # Base class for all errors raised if header isn't indicating a success
    class MainStatusError < Error
      attr_reader :error_sub_status

      def initialize(error_sub_status)
        @error_sub_status = error_sub_status
        super "Error sub status was: '#{error_sub_status}'"
      end
    end

    class UnauthorizedError < MainStatusError; end
    class UnauthenticatedError < MainStatusError; end
    class UnexpectedError < MainStatusError; end

    # A map of brreg's sub status codes to error class we will raise
    RESPONSE_SUB_STATUS_CODE_TO_ERROR = {
      -100  => UnauthorizedError,
      -101  => UnauthenticatedError,
      -1000 => UnexpectedError
    }.freeze

    def initialize(response)
      @response = response
      @header = response.header
    end

    # rubocop:disable Metrics/MethodLength
    def raise_error_or_return_response!
      return @response if @header.success?

      error_class = nil
      error_sub_status = nil

      case @header.sub_statuses.length
      when 0
        error_sub_status = 'Not included in response'
        error_class = UnexpectedError
      when 1
        error_sub_status = @header.sub_statuses[0]
        code = error_sub_status[:code]
        error_class = RESPONSE_SUB_STATUS_CODE_TO_ERROR.fetch(code) { UnexpectedError }
      else
        raise Error, "Expected 0 or 1 sub status. Got: #{@header.sub_statuses}"
      end

      raise error_class, error_sub_status
    end
    # rubocop:enable Metrics/MethodLength
  end
end

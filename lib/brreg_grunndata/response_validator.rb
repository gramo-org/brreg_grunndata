module BrregGrunndata
  class ResponseValidator
    # Base class for all errors raised if header isn't indicating a success
    class MainStatusError < Error
      attr_reader :error_status

      def initialize(error_status)
        @error_status = error_status
        super "Error status was: #{error_status}"
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

    def raise_error_or_return_response!
      return @response if @header.success?

      if @header.sub_statuses.length != 1
        raise Error, "Expected only 1 sub status. Got: #{@header.sub_statuses}"
      end

      error_status = @header.sub_statuses[0]
      code = error_status[:code]
      error_class = RESPONSE_SUB_STATUS_CODE_TO_ERROR.fetch(code) { UnexpectedError }

      raise error_class, error_status
    end
  end
end

# frozen_string_literal: true

module BrregGrunndata
  module Types
    class Organization
      def self.from_response(response)
        response.message
      end
    end
  end
end

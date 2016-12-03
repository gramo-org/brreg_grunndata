# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

module BrregGrunndata
  module Types
    # Include Dry basic types
    #
    # Whenever you see something like Types::String it is a dry type
    include Dry::Types.module
  end

  # Base class for all BrregGrunndata's types
  class Base < Dry::Struct
  end
end

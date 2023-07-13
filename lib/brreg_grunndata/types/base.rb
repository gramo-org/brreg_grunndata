# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

require_relative '../utils'

module BrregGrunndata
  module Types
    # Include Dry basic types
    #
    # Whenever you see something like Types::String it is a dry type
    include Dry.Types()

    # Base class for all BrregGrunndata's types
    class Base < Dry::Struct
      # Allow missing keys in the input data.
      # Missing data will get default value or nil.
      transform_types { |t| t.omittable }

      # Merges two base objects together and returns a new instance
      #
      # @return a new instance of self, filled/merged with data from other
      def merge(other)
        Utils::BaseTypeMerger.new(self, other).merge
      end
    end
  end
end

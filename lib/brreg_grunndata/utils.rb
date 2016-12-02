# frozen_string_literal: true

module BrregGrunndata
  module Utils
    module StringExt
      NAMESPACE_SEPARATOR = '::'.freeze
      UNDERSCORE_SEPARATOR = '/'.freeze
      UNDERSCORE_DIVISION_TARGET = '\1_\2'.freeze

      refine String do
        # Underscores a string
        #
        # Taken from
        # https://github.com/hanami/utils/blob/a2c9fe966ecc4e1997ffb616c7e57fc6e7acfadd/lib/hanami/utils/string.rb#L154-L175
        def underscore
          new_string = gsub(NAMESPACE_SEPARATOR, UNDERSCORE_SEPARATOR)
          new_string.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
          new_string.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
          new_string.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
          new_string.downcase!
          new_string
        end
      end
    end
  end
end

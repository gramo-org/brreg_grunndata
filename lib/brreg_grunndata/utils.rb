# frozen_string_literal: true

module BrregGrunndata
  module Utils
    # Runs operations against a service or client concurrently
    class ConcurrentOperations
      class UnkownOperationError < Error; end

      def initialize(service_or_client, operations, args)
        @service_or_client = service_or_client
        @operations = operations
        @args = args
      end

      # Calls all operations
      #
      # NOTE  There hasn't been put much effort in to this class, so
      #       when it comes to timeour or error handling you may encounter
      #       situaitons it does not currently handle
      #
      # @return Array of all results. Same order as operations where given.
      def call
        results = []

        threads = @operations.each_with_index.map do |operation, index|
          Thread.new do
            results[index] = call_on_service_or_client operation
          end
        end

        threads.each(&:join)

        results
      end

      private

      def call_on_service_or_client(operation)
        unless @service_or_client.respond_to? operation
          raise UnkownOperationError, "#{@service_or_client} does not respond to #{operation}"
        end

        @service_or_client.public_send operation, **@args
      end
    end

    # Helper class to merge two objects instance of Types::Base.
    class BaseTypeMerger
      def initialize(a, b)
        if a.class != b.class
          raise ArgumentError, "#{b.class.name} is not of type #{a.class.name}"
        end

        @a = a
        @b = b
      end

      # Merges the two given classes a and b.
      #
      # @return A new instance of type @a
      def merge
        a_hash = without_empty_values @a.to_h
        b_hash = without_empty_values @b.to_h

        @a.class.new a_hash.merge b_hash
      end

      private

      def without_empty_values(hash)
        hash.delete_if { |_k, v| v.nil? }
      end
    end

    module StringExt
      NAMESPACE_SEPARATOR = '::'
      UNDERSCORE_SEPARATOR = '/'
      UNDERSCORE_DIVISION_TARGET = '\1_\2'

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

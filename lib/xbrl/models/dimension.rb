# frozen_string_literal: true

module Xbrl
  module Models
    # Represents an XBRL dimension
    # Dimensions provide additional context categorization beyond period and entity
    class Dimension
      attr_reader :name, :value, :type, :namespace

      # @param name [String] Dimension name
      # @param value [String] Dimension value (member for explicit, typed value for typed)
      # @param type [Symbol] Dimension type (:explicit or :typed)
      # @param namespace [String, nil] Namespace prefix
      def initialize(name:, value:, type: :explicit, namespace: nil)
        @name = name
        @value = value
        @type = type.to_sym
        @namespace = namespace

        freeze
      end

      # Check if this is an explicit dimension
      # @return [Boolean]
      def explicit?
        type == :explicit
      end

      # Check if this is a typed dimension
      # @return [Boolean]
      def typed?
        type == :typed
      end

      # Get qualified dimension name
      # @return [String]
      def qualified_name
        namespace ? "#{namespace}:#{name}" : name
      end

      # Get qualified value (for explicit dimensions)
      # @return [String]
      def qualified_value
        return value if typed?

        # For explicit dimensions, value might have namespace
        value
      end
    end
  end
end

# frozen_string_literal: true

# rbs_inline: enabled

module XBRL
  module Models
    # Represents an XBRL dimension
    # Dimensions provide additional context categorization beyond period and entity
    class Dimension
      attr_reader :name, :value, :type, :namespace

      #: (name: String, value: String, ?type: Symbol, ?namespace: String?) -> void
      def initialize(name:, value:, type: :explicit, namespace: nil)
        @name = name
        @value = value
        @type = type.to_sym
        @namespace = namespace

        freeze
      end

      # Check if this is an explicit dimension
      #: () -> bool
      def explicit?
        type == :explicit
      end

      # Check if this is a typed dimension
      #: () -> bool
      def typed?
        type == :typed
      end

      # Get qualified dimension name
      #: () -> String
      def qualified_name
        namespace ? "#{namespace}:#{name}" : name
      end

      # Get qualified value (for explicit dimensions)
      #: () -> String
      def qualified_value
        return value if typed?

        # For explicit dimensions, value might have namespace
        value
      end
    end
  end
end

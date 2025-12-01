# frozen_string_literal: true

# rbs_inline: enabled

module XBRL
  module Models
    # Represents an XBRL fact (data point)
    # Facts are the actual data values in an XBRL document
    class Fact
      attr_reader :name, :value, :context_ref, :unit_ref,
                  :decimals, :namespace, :attributes

      #: (
      #     name: String,
      #     value: String,
      #     context_ref: String,
      #     namespace: String?,
      #     ?unit_ref: String?,
      #     ?decimals: String?,
      #     ?attributes: Hash[String, String]
      #   ) -> void
      def initialize(name:, value:, context_ref:, namespace:,
                     unit_ref: nil, decimals: nil, attributes: {})
        @name = name
        @value = value
        @context_ref = context_ref
        @unit_ref = unit_ref
        @decimals = decimals
        @namespace = namespace
        @attributes = attributes

        freeze
      end

      # Check if this is a numeric fact
      #: () -> bool
      def numeric?
        !unit_ref.nil? && value.to_s.match?(/^-?\d+(\.\d+)?$/)
      end

      # Convert to integer
      #: () -> Integer?
      def to_i
        return nil unless numeric?

        value.to_i
      end

      # Convert to float
      #: () -> Float?
      def to_f
        return nil unless numeric?

        value.to_f
      end

      # Convert to string
      #: () -> String
      def to_s
        value.to_s
      end

      # Get the full qualified name with namespace
      #: () -> String
      def qualified_name
        namespace ? "#{namespace}:#{name}" : name
      end
    end
  end
end

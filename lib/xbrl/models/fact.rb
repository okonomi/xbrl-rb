# frozen_string_literal: true

module XBRL
  module Models
    # Represents an XBRL fact (data point)
    # Facts are the actual data values in an XBRL document
    class Fact
      attr_reader :name, :value, :context_ref, :unit_ref,
                  :decimals, :namespace, :attributes

      # @param name [String] Fact name (concept name without namespace prefix)
      # @param value [String] Fact value
      # @param context_ref [String] Reference to context ID
      # @param namespace [String] Namespace prefix
      # @param unit_ref [String, nil] Reference to unit ID (for numeric facts)
      # @param decimals [String, nil] Decimal precision indicator
      # @param attributes [Hash] Additional attributes
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
      # @return [Boolean]
      def numeric?
        !unit_ref.nil? && value.to_s.match?(/^-?\d+(\.\d+)?$/)
      end

      # Convert to integer
      # @return [Integer, nil]
      def to_i
        return nil unless numeric?

        value.to_i
      end

      # Convert to float
      # @return [Float, nil]
      def to_f
        return nil unless numeric?

        value.to_f
      end

      # Convert to string
      # @return [String]
      def to_s
        value.to_s
      end

      # Get the full qualified name with namespace
      # @return [String]
      def qualified_name
        namespace ? "#{namespace}:#{name}" : name
      end
    end
  end
end

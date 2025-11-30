# frozen_string_literal: true

module Xbrl
  module Models
    # Represents an XBRL unit
    # Units define the measurement unit for numeric facts (e.g., currency, shares)
    class Unit
      attr_reader :id, :measures, :divide_measures

      # @param id [String] Unit identifier
      # @param measures [Array<String>] Numerator measures
      # @param divide_measures [Array<String>] Denominator measures for ratios (default: [])
      def initialize(id:, measures:, divide_measures: [])
        @id = id
        @measures = Array(measures)
        @divide_measures = Array(divide_measures)

        freeze
      end

      # Get the primary measure (first measure in the list)
      # @return [String, nil]
      def measure
        measures.first
      end

      # Check if this is a currency unit
      # @return [Boolean]
      def currency?
        return false unless measure

        measure.include?("iso4217") || measure.match?(/[A-Z]{3}$/)
      end

      # Check if this is a shares unit
      # @return [Boolean]
      def shares?
        return false unless measure

        measure.include?("shares") || measure.include?("Shares")
      end

      # Check if this is a pure number (no unit)
      # @return [Boolean]
      def pure?
        return false unless measure

        measure.include?("pure") || measure.include?("Pure")
      end

      # Check if this is a ratio (has divide measures)
      # @return [Boolean]
      def ratio?
        !divide_measures.empty?
      end
    end
  end
end

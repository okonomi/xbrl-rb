# frozen_string_literal: true

# rbs_inline: enabled

module XBRL
  module Models
    # Represents an XBRL unit
    # Units define the measurement unit for numeric facts (e.g., currency, shares)
    class Unit
      attr_reader :id, :measures, :divide_measures

      #: (id: String, measures: Array[String], ?divide_measures: Array[String]) -> void
      def initialize(id:, measures:, divide_measures: [])
        @id = id
        @measures = Array(measures)
        @divide_measures = Array(divide_measures)

        freeze
      end

      # Get the primary measure (first measure in the list)
      #: () -> String?
      def measure
        measures.first
      end

      # Check if this is a currency unit
      #: () -> bool
      def currency?
        return false unless measure

        measure.include?("iso4217") || measure.match?(/[A-Z]{3}$/)
      end

      # Check if this is a shares unit
      #: () -> bool
      def shares?
        return false unless measure

        measure.include?("shares") || measure.include?("Shares")
      end

      # Check if this is a pure number (no unit)
      #: () -> bool
      def pure?
        return false unless measure

        measure.include?("pure") || measure.include?("Pure")
      end

      # Check if this is a ratio (has divide measures)
      #: () -> bool
      def ratio?
        !divide_measures.empty?
      end
    end
  end
end

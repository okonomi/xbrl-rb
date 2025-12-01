# frozen_string_literal: true

# rbs_inline: enabled

require_relative "base_collection"

module XBRL
  module Collections
    # Collection of XBRL units with query methods
    class UnitCollection < BaseCollection
      # Find unit by ID
      #: (String) -> XBRL::Models::Unit?
      def find_by_id(id)
        find { |unit| unit.id == id }
      end

      # Get all currency units
      #: () -> Array[XBRL::Models::Unit]
      def currencies
        select(&:currency?)
      end

      # Get all share units
      #: () -> Array[XBRL::Models::Unit]
      def shares
        select(&:shares?)
      end

      # Get all pure/dimensionless units
      #: () -> Array[XBRL::Models::Unit]
      def pure
        select(&:pure?)
      end

      # Find units by measure
      #: (String) -> Array[XBRL::Models::Unit]
      def find_by_measure(measure)
        select { |unit| unit.measure == measure }
      end

      # Get all unique measures
      #: () -> Array[String]
      def measures
        map(&:measure).compact.uniq
      end

      # Group units by measure
      #: () -> Hash[String, Array[XBRL::Models::Unit]]
      def group_by_measure
        group_by(&:measure)
      end
    end
  end
end

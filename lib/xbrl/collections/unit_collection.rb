# frozen_string_literal: true

require_relative "base_collection"

module Xbrl
  module Collections
    # Collection of XBRL units with query methods
    class UnitCollection < BaseCollection
      # Find unit by ID
      # @param id [String] Unit ID
      # @return [Xbrl::Models::Unit, nil]
      def find_by_id(id)
        find { |unit| unit.id == id }
      end

      # Get all currency units
      # @return [Array<Xbrl::Models::Unit>]
      def currencies
        select(&:currency?)
      end

      # Get all share units
      # @return [Array<Xbrl::Models::Unit>]
      def shares
        select(&:shares?)
      end

      # Get all pure/dimensionless units
      # @return [Array<Xbrl::Models::Unit>]
      def pure
        select(&:pure?)
      end

      # Find units by measure
      # @param measure [String] Measure to search for
      # @return [Array<Xbrl::Models::Unit>]
      def find_by_measure(measure)
        select { |unit| unit.measure == measure }
      end

      # Get all unique measures
      # @return [Array<String>]
      def measures
        map(&:measure).compact.uniq
      end

      # Group units by measure
      # @return [Hash{String => Array<Xbrl::Models::Unit>}]
      def group_by_measure
        group_by(&:measure)
      end
    end
  end
end

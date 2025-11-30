# frozen_string_literal: true

require_relative "base_collection"

module Xbrl
  module Collections
    # Collection of XBRL contexts with query methods
    class ContextCollection < BaseCollection
      # Find context by ID
      # @param id [String] Context ID
      # @return [Xbrl::Models::Context, nil]
      def find_by_id(id)
        find { |context| context.id == id }
      end

      # Get all instant contexts
      # @return [Array<Xbrl::Models::Context>]
      def instant
        select(&:instant?)
      end

      # Get all duration contexts
      # @return [Array<Xbrl::Models::Context>]
      def duration
        select(&:duration?)
      end

      # Find contexts by entity identifier
      # @param identifier [String] Entity identifier
      # @return [Array<Xbrl::Models::Context>]
      def find_by_entity(identifier)
        select { |context| context.entity_id == identifier }
      end

      # Get all unique entity identifiers
      # @return [Array<String>]
      def entity_identifiers
        map(&:entity_id).compact.uniq
      end

      # Group contexts by entity identifier
      # @return [Hash{String => Array<Xbrl::Models::Context>}]
      def group_by_entity
        group_by(&:entity_id)
      end

      # Get contexts with dimensions
      # @return [Array<Xbrl::Models::Context>]
      def with_dimensions
        select(&:dimensions?)
      end

      # Get contexts without dimensions
      # @return [Array<Xbrl::Models::Context>]
      def without_dimensions
        reject(&:dimensions?)
      end

      # Find contexts by dimension value
      # @param dimension_name [String] Dimension name
      # @param value [String, nil] Dimension value (nil returns all contexts with this dimension)
      # @return [Array<Xbrl::Models::Context>]
      def find_by_dimension(dimension_name, value = nil)
        select do |context|
          dim = context.dimension(dimension_name)
          next false unless dim

          value.nil? || dim.value == value
        end
      end
    end
  end
end

# frozen_string_literal: true

# rbs_inline: enabled

require_relative "base_collection"

module XBRL
  module Collections
    # Collection of XBRL contexts with query methods
    class ContextCollection < BaseCollection
      # Find context by ID
      #: (String) -> XBRL::Models::Context?
      def find_by_id(id)
        find { |context| context.id == id }
      end

      # Get all instant contexts
      #: () -> Array[XBRL::Models::Context]
      def instant
        select(&:instant?)
      end

      # Get all duration contexts
      #: () -> Array[XBRL::Models::Context]
      def duration
        select(&:duration?)
      end

      # Find contexts by entity identifier
      #: (String) -> Array[XBRL::Models::Context]
      def find_by_entity(identifier)
        select { |context| context.entity_id == identifier }
      end

      # Get all unique entity identifiers
      #: () -> Array[String]
      def entity_identifiers
        map(&:entity_id).compact.uniq
      end

      # Group contexts by entity identifier
      #: () -> Hash[String, Array[XBRL::Models::Context]]
      def group_by_entity
        group_by(&:entity_id)
      end

      # Get contexts with dimensions
      #: () -> Array[XBRL::Models::Context]
      def with_dimensions
        select(&:dimensions?)
      end

      # Get contexts without dimensions
      #: () -> Array[XBRL::Models::Context]
      def without_dimensions
        reject(&:dimensions?)
      end

      # Find contexts by dimension value
      #: (String dimension_name, ?String? value) -> Array[XBRL::Models::Context]
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

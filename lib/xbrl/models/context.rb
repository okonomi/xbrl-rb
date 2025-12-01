# frozen_string_literal: true

# rbs_inline: enabled

module XBRL
  module Models
    # Represents an XBRL context
    # Contexts provide dimensional information for facts (period, entity, scenarios)
    class Context
      attr_reader :id, :entity_scheme, :entity_id, :period_type,
                  :start_date, :end_date, :instant_date, :dimensions

      #: (
      #     id: String,
      #     entity_scheme: String,
      #     entity_id: String,
      #     period_type: Symbol,
      #     ?start_date: String?,
      #     ?end_date: String?,
      #     ?instant_date: String?,
      #     ?dimensions: Hash[String, Dimension]
      #   ) -> void
      def initialize(id:, entity_scheme:, entity_id:, period_type:,
                     start_date: nil, end_date: nil, instant_date: nil,
                     dimensions: {})
        @id = id
        @entity_scheme = entity_scheme
        @entity_id = entity_id
        @period_type = period_type.to_sym
        @start_date = parse_date(start_date)
        @end_date = parse_date(end_date)
        @instant_date = parse_date(instant_date)
        @dimensions = dimensions

        freeze
      end

      # Check if this is a duration period
      #: () -> bool
      def duration?
        period_type == :duration
      end

      # Check if this is an instant period
      #: () -> bool
      def instant?
        period_type == :instant
      end

      # Check if context has dimensions
      #: () -> bool
      def dimensions?
        !dimensions.empty?
      end

      # Get dimension by name
      #: (String) -> Dimension?
      def dimension(name)
        dimensions[name]
      end

      # Get all dimension names
      #: () -> Array[String]
      def dimension_names
        dimensions.keys
      end

      # Get explicit dimensions only
      #: () -> Hash[String, Dimension]
      def explicit_dimensions
        dimensions.select { |_name, dim| dim.explicit? }
      end

      # Get typed dimensions only
      #: () -> Hash[String, Dimension]
      def typed_dimensions
        dimensions.select { |_name, dim| dim.typed? }
      end

      private

      # Parse date string into Date object
      #: (String?) -> Date?
      def parse_date(date_string)
        return nil if date_string.nil? || date_string.empty?

        Date.parse(date_string)
      rescue ArgumentError
        nil
      end
    end
  end
end

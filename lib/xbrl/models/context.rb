# frozen_string_literal: true

module Xbrl
  module Models
    # Represents an XBRL context
    # Contexts provide dimensional information for facts (period, entity, scenarios)
    class Context
      attr_reader :id, :entity_scheme, :entity_id, :period_type,
                  :start_date, :end_date, :instant_date, :dimensions

      # @param id [String] Context identifier
      # @param entity_scheme [String] Entity identifier scheme
      # @param entity_id [String] Entity identifier value
      # @param period_type [Symbol] Period type (:duration or :instant)
      # @param start_date [String, nil] Start date for duration periods (YYYY-MM-DD)
      # @param end_date [String, nil] End date for duration periods (YYYY-MM-DD)
      # @param instant_date [String, nil] Instant date for instant periods (YYYY-MM-DD)
      # @param dimensions [Hash] Dimension members (default: {})
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
      # @return [Boolean]
      def duration?
        period_type == :duration
      end

      # Check if this is an instant period
      # @return [Boolean]
      def instant?
        period_type == :instant
      end

      private

      # Parse date string into Date object
      # @param date_string [String, nil] Date in YYYY-MM-DD format
      # @return [Date, nil]
      def parse_date(date_string)
        return nil if date_string.nil? || date_string.empty?

        Date.parse(date_string)
      rescue ArgumentError
        nil
      end
    end
  end
end

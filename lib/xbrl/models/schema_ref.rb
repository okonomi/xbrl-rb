# frozen_string_literal: true

module XBRL
  module Models
    # Represents an XBRL schema reference
    # Schema references link to taxonomy schemas
    class SchemaRef
      attr_reader :href, :type

      # @param href [String] Schema URI
      # @param type [String] Link type (typically "simple")
      def initialize(href:, type: "simple")
        @href = href
        @type = type

        freeze
      end
    end
  end
end

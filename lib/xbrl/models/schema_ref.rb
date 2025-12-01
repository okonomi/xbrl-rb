# frozen_string_literal: true

# rbs_inline: enabled

module XBRL
  module Models
    # Represents an XBRL schema reference
    # Schema references link to taxonomy schemas
    class SchemaRef
      attr_reader :href, :type

      #: (href: String, ?type: String) -> void
      def initialize(href:, type: "simple")
        @href = href
        @type = type

        freeze
      end
    end
  end
end

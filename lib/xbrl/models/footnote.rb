# frozen_string_literal: true

# rbs_inline: enabled

module XBRL
  module Models
    # Represents an XBRL footnote
    # Footnotes provide additional information about facts
    class Footnote
      attr_reader :id, :text, :lang

      #: (id: String, text: String, ?lang: String?) -> void
      def initialize(id:, text:, lang: nil)
        @id = id
        @text = text
        @lang = lang

        freeze
      end

      # Check if footnote has a specific language
      #: (String) -> bool
      def language?(language)
        lang == language
      end

      # Get footnote as plain text
      #: () -> String
      def to_s
        text
      end
    end
  end
end

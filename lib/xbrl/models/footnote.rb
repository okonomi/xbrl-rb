# frozen_string_literal: true

module Xbrl
  module Models
    # Represents an XBRL footnote
    # Footnotes provide additional information about facts
    class Footnote
      attr_reader :id, :text, :lang

      # @param id [String] Footnote identifier
      # @param text [String] Footnote text content
      # @param lang [String, nil] Language code (e.g., "ja", "en")
      def initialize(id:, text:, lang: nil)
        @id = id
        @text = text
        @lang = lang

        freeze
      end

      # Check if footnote has a specific language
      # @param language [String] Language code to check
      # @return [Boolean]
      def language?(language)
        lang == language
      end

      # Get footnote as plain text
      # @return [String]
      def to_s
        text
      end
    end
  end
end

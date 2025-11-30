# frozen_string_literal: true

module Xbrl
  # Base error class for all XBRL-related errors
  class Error < StandardError; end

  # Raised when XML parsing fails
  class ParseError < Error; end

  # Raised when an XBRL document is invalid or malformed
  class InvalidDocumentError < Error; end

  # Raised when a referenced context cannot be found
  class ContextNotFoundError < Error; end

  # Raised when a referenced unit cannot be found
  class UnitNotFoundError < Error; end
end

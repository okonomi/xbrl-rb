# frozen_string_literal: true

require_relative "xbrl/version"

# Core
require_relative "xbrl/errors"
require_relative "xbrl/namespace"

# Models
require_relative "xbrl/models/context"
require_relative "xbrl/models/unit"
require_relative "xbrl/models/fact"
require_relative "xbrl/models/schema_ref"
require_relative "xbrl/models/footnote"
require_relative "xbrl/models/dimension"

# Collections
require_relative "xbrl/collections/base_collection"
require_relative "xbrl/collections/context_collection"
require_relative "xbrl/collections/unit_collection"
require_relative "xbrl/collections/fact_collection"

# Parser and Document
require_relative "xbrl/parser"
require_relative "xbrl/document"

# XBRL parser for Ruby
#
# This module provides functionality for parsing XBRL (eXtensible Business Reporting Language)
# instance documents with a focus on Japanese financial reporting formats (EDINET/TDnet).
#
# @example Parse an XBRL document
#   doc = XBRL.parse("path/to/instance.xml")
#   doc.facts.each { |fact| puts "#{fact.name}: #{fact.value}" }
module XBRL
  # Parse an XBRL document from a file
  # @param file_path [String] Path to XBRL file
  # @return [Document]
  def self.parse(file_path)
    content = File.read(file_path, encoding: "UTF-8")
    parse_string(content)
  rescue Errno::ENOENT => e
    raise InvalidDocumentError, "File not found: #{e.message}"
  rescue StandardError => e
    raise InvalidDocumentError, "Failed to read file: #{e.message}"
  end

  # Parse an XBRL document from a string
  # @param xml_string [String] XML content
  # @return [Document]
  def self.parse_string(xml_string)
    parser = Parser.new(xml_string)
    data = parser.parse

    Document.new(
      contexts: data[:contexts],
      units: data[:units],
      facts: data[:facts],
      schema_refs: data[:schema_refs],
      footnotes: data[:footnotes]
    )
  rescue ParseError => e
    raise InvalidDocumentError, e.message
  end
end

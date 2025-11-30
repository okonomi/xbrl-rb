# frozen_string_literal: true

module Xbrl
  # Represents an XBRL instance document
  class Document
    attr_reader :contexts, :units, :facts, :schema_refs, :footnotes

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

      new(
        contexts: data[:contexts],
        units: data[:units],
        facts: data[:facts],
        schema_refs: data[:schema_refs],
        footnotes: data[:footnotes]
      )
    end

    # @param contexts [Array<Models::Context>] Contexts
    # @param units [Array<Models::Unit>] Units
    # @param facts [Array<Models::Fact>] Facts
    # @param schema_refs [Array<Models::SchemaRef>] Schema references
    # @param footnotes [Array<Models::Footnote>] Footnotes
    def initialize(contexts:, units:, facts: [], schema_refs: [], footnotes: [])
      @contexts = Collections::ContextCollection.new(contexts)
      @units = Collections::UnitCollection.new(units)
      @facts = Collections::FactCollection.new(facts)
      @schema_refs = schema_refs
      @footnotes = footnotes

      freeze
    end

    # Find a context by ID
    # @param id [String] Context ID
    # @return [Models::Context, nil]
    def find_context(id)
      contexts.find_by_id(id)
    end

    # Find a unit by ID
    # @param id [String] Unit ID
    # @return [Models::Unit, nil]
    def find_unit(id)
      units.find_by_id(id)
    end

    # Find a footnote by ID
    # @param id [String] Footnote ID
    # @return [Models::Footnote, nil]
    def find_footnote(id)
      footnotes.find { |footnote| footnote.id == id }
    end
  end
end

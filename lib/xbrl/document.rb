# frozen_string_literal: true

module Xbrl
  # Represents an XBRL instance document
  class Document
    attr_reader :contexts, :units

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
        units: data[:units]
      )
    end

    # @param contexts [Array<Models::Context>] Contexts
    # @param units [Array<Models::Unit>] Units
    def initialize(contexts:, units:)
      @contexts = contexts
      @units = units

      freeze
    end

    # Find a context by ID
    # @param id [String] Context ID
    # @return [Models::Context, nil]
    def find_context(id)
      contexts.find { |ctx| ctx.id == id }
    end

    # Find a unit by ID
    # @param id [String] Unit ID
    # @return [Models::Unit, nil]
    def find_unit(id)
      units.find { |unit| unit.id == id }
    end
  end
end

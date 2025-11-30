# frozen_string_literal: true

module XBRL
  # Represents an XBRL instance document
  class Document
    attr_reader :contexts, :units, :facts, :schema_refs, :footnotes

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

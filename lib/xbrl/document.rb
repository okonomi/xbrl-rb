# frozen_string_literal: true

# rbs_inline: enabled

module XBRL
  # Represents an XBRL instance document
  class Document
    attr_reader :contexts, :units, :facts, :schema_refs, :footnotes

    #: (
    #     contexts: Array[Models::Context],
    #     units: Array[Models::Unit],
    #     ?facts: Array[Models::Fact],
    #     ?schema_refs: Array[Models::SchemaRef],
    #     ?footnotes: Array[Models::Footnote]
    #   ) -> void
    def initialize(contexts:, units:, facts: [], schema_refs: [], footnotes: [])
      @contexts = Collections::ContextCollection.new(contexts)
      @units = Collections::UnitCollection.new(units)
      @facts = Collections::FactCollection.new(facts)
      @schema_refs = schema_refs
      @footnotes = footnotes

      freeze
    end

    # Find a context by ID
    #: (String) -> Models::Context?
    def find_context(id)
      contexts.find_by_id(id)
    end

    # Find a unit by ID
    #: (String) -> Models::Unit?
    def find_unit(id)
      units.find_by_id(id)
    end

    # Find a footnote by ID
    #: (String) -> Models::Footnote?
    def find_footnote(id)
      footnotes.find { |footnote| footnote.id == id }
    end
  end
end

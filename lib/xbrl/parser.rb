# frozen_string_literal: true

# rbs_inline: enabled

require "ox"
require "date"

module XBRL
  # Internal XML parser for XBRL documents
  class Parser
    # XBRL structural element names (not facts)
    STRUCTURAL_ELEMENTS = %w[
      context unit schemaRef linkbaseRef roleRef arcroleRef footnoteLink
      link loc label reference part
    ].freeze
    #: (String) -> void
    def initialize(xml_content)
      @doc = Ox.parse(xml_content)
    rescue Ox::ParseError => e
      raise ParseError, "Invalid XML: #{e.message}"
    end

    # Parse the XBRL document
    #: () -> Hash[Symbol, Array[Models::Context | Models::Unit | Models::Fact | Models::SchemaRef | Models::Footnote]]
    def parse
      {
        contexts: parse_contexts,
        units: parse_units,
        facts: parse_facts,
        schema_refs: parse_schema_refs,
        footnotes: parse_footnotes
      }
    end

    private

    # Find all elements with a specific name
    #: (String) -> Array[untyped]
    def find_elements(element_name)
      results = []
      traverse(@doc) do |node|
        next unless node.is_a?(Ox::Element)

        results << node if Namespace.strip_namespace(node.name) == element_name
      end
      results
    end

    # Traverse XML tree depth-first
    #: (untyped node) { (untyped) -> void } -> void
    def traverse(node, &block)
      yield node if block_given?

      return unless node.respond_to?(:nodes)

      node.nodes.each do |child|
        traverse(child, &block)
      end
    end

    # Get text content of first child element with given name
    #: (untyped, String) -> String?
    def get_element_text(parent, element_name)
      return nil unless parent.respond_to?(:nodes)

      parent.nodes.each do |child|
        next unless child.is_a?(Ox::Element)
        return extract_text(child) if Namespace.strip_namespace(child.name) == element_name
      end
      nil
    end

    # Get first child element with given name
    #: (untyped, String) -> untyped
    def get_element(parent, element_name)
      return nil unless parent.respond_to?(:nodes)

      parent.nodes.each do |child|
        next unless child.is_a?(Ox::Element)
        return child if Namespace.strip_namespace(child.name) == element_name
      end
      nil
    end

    # Extract text content from element
    #: (untyped) -> String
    def extract_text(element)
      return "" unless element.respond_to?(:nodes)

      element.nodes.map do |node|
        if node.is_a?(String)
          node
        elsif node.respond_to?(:text)
          node.text
        else
          ""
        end
      end.join.strip
    end

    # Parse all context elements
    #: () -> Array[Models::Context]
    def parse_contexts
      find_elements("context").map do |context_node|
        parse_context(context_node)
      end.compact
    end

    # Parse a single context element
    #: (untyped) -> Models::Context?
    def parse_context(context_node)
      id = context_node[:id]
      return nil unless id

      entity = get_element(context_node, "entity")
      return nil unless entity

      identifier = get_element(entity, "identifier")
      return nil unless identifier

      entity_scheme = identifier[:scheme] || ""
      entity_id = extract_text(identifier)

      period = get_element(context_node, "period")
      return nil unless period

      period_data = parse_period(period)
      return nil unless period_data

      # Parse dimensions from segment or scenario
      dimensions = parse_dimensions(entity, context_node)

      Models::Context.new(
        id: id,
        entity_scheme: entity_scheme,
        entity_id: entity_id,
        period_type: period_data[:type],
        start_date: period_data[:start_date],
        end_date: period_data[:end_date],
        instant_date: period_data[:instant_date],
        dimensions: dimensions
      )
    rescue StandardError => e
      warn "Failed to parse context: #{e.message}"
      nil
    end

    # Parse period element
    #: (untyped) -> Hash[Symbol, untyped]?
    def parse_period(period)
      if get_element(period, "instant")
        {
          type: :instant,
          instant_date: get_element_text(period, "instant")
        }
      elsif get_element(period, "startDate") && get_element(period, "endDate")
        {
          type: :duration,
          start_date: get_element_text(period, "startDate"),
          end_date: get_element_text(period, "endDate")
        }
      end
    end

    # Parse all unit elements
    #: () -> Array[Models::Unit]
    def parse_units
      find_elements("unit").map do |unit_node|
        parse_unit(unit_node)
      end.compact
    end

    # Parse a single unit element
    #: (untyped) -> Models::Unit?
    def parse_unit(unit_node)
      id = unit_node[:id]
      return nil unless id

      measures = []
      divide_measures = []

      unit_node.nodes.each do |child|
        next unless child.is_a?(Ox::Element)

        case Namespace.strip_namespace(child.name)
        when "measure"
          measures << extract_text(child)
        when "divide"
          # Handle divide element for ratios
          child.nodes.each do |div_child|
            next unless div_child.is_a?(Ox::Element)

            divide_measures << extract_text(div_child) if Namespace.strip_namespace(div_child.name) == "measure"
          end
        end
      end

      return nil if measures.empty?

      Models::Unit.new(
        id: id,
        measures: measures,
        divide_measures: divide_measures
      )
    rescue StandardError => e
      warn "Failed to parse unit: #{e.message}"
      nil
    end

    # Parse all fact elements
    #: () -> Array[Models::Fact]
    def parse_facts
      facts = []
      traverse(@doc) do |node|
        next unless node.is_a?(Ox::Element)

        element_name = Namespace.strip_namespace(node.name)
        next if STRUCTURAL_ELEMENTS.include?(element_name)

        # Check if this looks like a fact (has contextRef attribute)
        context_ref = node[:contextRef]
        next unless context_ref

        fact = parse_fact(node)
        facts << fact if fact
      end
      facts
    end

    # Parse a single fact element
    #: (untyped) -> Models::Fact?
    def parse_fact(fact_node)
      name = Namespace.strip_namespace(fact_node.name)
      namespace = Namespace.extract_prefix(fact_node.name)
      context_ref = fact_node[:contextRef]
      unit_ref = fact_node[:unitRef]
      decimals = fact_node[:decimals]
      value = extract_text(fact_node)

      # Collect all other attributes
      attributes = {}
      fact_node.attributes.each do |attr_name, attr_value|
        next if %i[contextRef unitRef decimals].include?(attr_name)

        attributes[attr_name.to_s] = attr_value
      end

      Models::Fact.new(
        name: name,
        value: value,
        context_ref: context_ref,
        namespace: namespace,
        unit_ref: unit_ref,
        decimals: decimals,
        attributes: attributes
      )
    rescue StandardError => e
      warn "Failed to parse fact: #{e.message}"
      nil
    end

    # Parse all schema reference elements
    #: () -> Array[Models::SchemaRef]
    def parse_schema_refs
      find_elements("schemaRef").map do |schema_ref_node|
        parse_schema_ref(schema_ref_node)
      end.compact
    end

    # Parse a single schema reference element
    #: (untyped) -> Models::SchemaRef?
    def parse_schema_ref(schema_ref_node)
      href = schema_ref_node[:href]
      return nil unless href

      type = schema_ref_node[:type] || "simple"

      Models::SchemaRef.new(
        href: href,
        type: type
      )
    rescue StandardError => e
      warn "Failed to parse schema reference: #{e.message}"
      nil
    end

    # Parse all footnote elements
    #: () -> Array[Models::Footnote]
    def parse_footnotes
      footnotes = []
      find_elements("footnoteLink").each do |footnote_link|
        footnote_link.nodes.each do |child|
          next unless child.is_a?(Ox::Element)
          next unless Namespace.strip_namespace(child.name) == "footnote"

          footnote = parse_footnote(child)
          footnotes << footnote if footnote
        end
      end
      footnotes
    end

    # Parse a single footnote element
    #: (untyped) -> Models::Footnote?
    def parse_footnote(footnote_node)
      id = footnote_node[:id]
      return nil unless id

      text = extract_text(footnote_node)
      lang = footnote_node[:"xml:lang"] || footnote_node[:lang]

      Models::Footnote.new(
        id: id,
        text: text,
        lang: lang
      )
    rescue StandardError => e
      warn "Failed to parse footnote: #{e.message}"
      nil
    end

    # Parse dimensions from entity segment or scenario
    #: (untyped, untyped) -> Hash[String, Models::Dimension]
    def parse_dimensions(entity, context_node)
      dimensions = {}

      # Parse dimensions from entity segment
      segment = get_element(entity, "segment")
      dimensions.merge!(parse_dimension_container(segment)) if segment

      # Parse dimensions from scenario
      scenario = get_element(context_node, "scenario")
      dimensions.merge!(parse_dimension_container(scenario)) if scenario

      dimensions
    end

    # Parse dimensions from a container element (segment or scenario)
    #: (untyped) -> Hash[String, Models::Dimension]
    def parse_dimension_container(container)
      dimensions = {}

      return dimensions unless container.respond_to?(:nodes)

      container.nodes.each do |node|
        next unless node.is_a?(Ox::Element)

        element_name = Namespace.strip_namespace(node.name)

        # Parse explicit dimension members
        if element_name == "explicitMember"
          dimension_name = node[:dimension]
          next unless dimension_name

          dimension_name = Namespace.strip_namespace(dimension_name)
          value = extract_text(node)
          namespace = Namespace.extract_prefix(node.name)

          dimensions[dimension_name] = Models::Dimension.new(
            name: dimension_name,
            value: value,
            type: :explicit,
            namespace: namespace
          )
        # Parse typed dimension members
        elsif element_name == "typedMember"
          dimension_name = node[:dimension]
          next unless dimension_name

          dimension_name = Namespace.strip_namespace(dimension_name)
          value = extract_text(node)
          namespace = Namespace.extract_prefix(node.name)

          dimensions[dimension_name] = Models::Dimension.new(
            name: dimension_name,
            value: value,
            type: :typed,
            namespace: namespace
          )
        end
      end

      dimensions
    rescue StandardError => e
      warn "Failed to parse dimensions: #{e.message}"
      {}
    end
  end
end

# frozen_string_literal: true

require "ox"
require "date"

module Xbrl
  # Internal XML parser for XBRL documents
  class Parser
    # XBRL structural element names (not facts)
    STRUCTURAL_ELEMENTS = %w[
      context unit schemaRef linkbaseRef roleRef arcroleRef footnoteLink
      link loc label reference part
    ].freeze
    # @param xml_content [String] XML content to parse
    def initialize(xml_content)
      @doc = Ox.parse(xml_content)
    rescue Ox::ParseError => e
      raise ParseError, "Invalid XML: #{e.message}"
    end

    # Parse the XBRL document
    # @return [Hash] Parsed data with :contexts, :units, and :facts keys
    def parse
      {
        contexts: parse_contexts,
        units: parse_units,
        facts: parse_facts
      }
    end

    private

    # Find all elements with a specific name
    # @param element_name [String] Element name to search for
    # @return [Array<Ox::Element>]
    def find_elements(element_name)
      results = []
      traverse(@doc) do |node|
        next unless node.is_a?(Ox::Element)

        results << node if Namespace.strip_namespace(node.name) == element_name
      end
      results
    end

    # Traverse XML tree depth-first
    # @param node [Ox::Element, Ox::Document] Node to start traversal from
    # @yield [Ox::Element] Each element in the tree
    def traverse(node, &block)
      yield node if block_given?

      return unless node.respond_to?(:nodes)

      node.nodes.each do |child|
        traverse(child, &block)
      end
    end

    # Get text content of first child element with given name
    # @param parent [Ox::Element] Parent element
    # @param element_name [String] Child element name to find
    # @return [String, nil]
    def get_element_text(parent, element_name)
      return nil unless parent.respond_to?(:nodes)

      parent.nodes.each do |child|
        next unless child.is_a?(Ox::Element)
        return extract_text(child) if Namespace.strip_namespace(child.name) == element_name
      end
      nil
    end

    # Get first child element with given name
    # @param parent [Ox::Element] Parent element
    # @param element_name [String] Child element name to find
    # @return [Ox::Element, nil]
    def get_element(parent, element_name)
      return nil unless parent.respond_to?(:nodes)

      parent.nodes.each do |child|
        next unless child.is_a?(Ox::Element)
        return child if Namespace.strip_namespace(child.name) == element_name
      end
      nil
    end

    # Extract text content from element
    # @param element [Ox::Element] Element to extract text from
    # @return [String]
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
    # @return [Array<Models::Context>]
    def parse_contexts
      find_elements("context").map do |context_node|
        parse_context(context_node)
      end.compact
    end

    # Parse a single context element
    # @param context_node [Ox::Element] Context element
    # @return [Models::Context, nil]
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

      Models::Context.new(
        id: id,
        entity_scheme: entity_scheme,
        entity_id: entity_id,
        period_type: period_data[:type],
        start_date: period_data[:start_date],
        end_date: period_data[:end_date],
        instant_date: period_data[:instant_date],
        dimensions: {}
      )
    rescue StandardError => e
      warn "Failed to parse context: #{e.message}"
      nil
    end

    # Parse period element
    # @param period [Ox::Element] Period element
    # @return [Hash, nil] Hash with :type, :start_date, :end_date, :instant_date
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
    # @return [Array<Models::Unit>]
    def parse_units
      find_elements("unit").map do |unit_node|
        parse_unit(unit_node)
      end.compact
    end

    # Parse a single unit element
    # @param unit_node [Ox::Element] Unit element
    # @return [Models::Unit, nil]
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
    # @return [Array<Models::Fact>]
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
    # @param fact_node [Ox::Element] Fact element
    # @return [Models::Fact, nil]
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
  end
end

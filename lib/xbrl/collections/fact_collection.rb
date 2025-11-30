# frozen_string_literal: true

module Xbrl
  module Collections
    # Collection of XBRL facts with query methods
    class FactCollection < BaseCollection
      # Find facts by name
      # @param name [String] Fact name (without namespace prefix)
      # @return [Array<Models::Fact>]
      def find_by_name(name)
        select { |fact| fact.name == name }
      end

      # Find facts by context reference
      # @param context_ref [String] Context ID
      # @return [Array<Models::Fact>]
      def find_by_context(context_ref)
        select { |fact| fact.context_ref == context_ref }
      end

      # Find facts by unit reference
      # @param unit_ref [String] Unit ID
      # @return [Array<Models::Fact>]
      def find_by_unit(unit_ref)
        select { |fact| fact.unit_ref == unit_ref }
      end

      # Find facts by namespace
      # @param namespace [String] Namespace prefix
      # @return [Array<Models::Fact>]
      def find_by_namespace(namespace)
        select { |fact| fact.namespace == namespace }
      end

      # Get only numeric facts
      # @return [Array<Models::Fact>]
      def numeric
        select(&:numeric?)
      end

      # Get only non-numeric (text) facts
      # @return [Array<Models::Fact>]
      def text
        reject(&:numeric?)
      end

      # Group facts by name
      # @return [Hash{String => Array<Models::Fact>}]
      def group_by_name
        group_by(&:name)
      end

      # Group facts by context
      # @return [Hash{String => Array<Models::Fact>}]
      def group_by_context
        group_by(&:context_ref)
      end

      # Get unique fact names
      # @return [Array<String>]
      def names
        map(&:name).uniq
      end
    end
  end
end

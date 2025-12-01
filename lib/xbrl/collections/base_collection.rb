# frozen_string_literal: true

# rbs_inline: enabled

module XBRL
  module Collections
    # Base collection class providing Enumerable functionality
    class BaseCollection
      include Enumerable

      #: Array[untyped]
      attr_reader :items

      #: (?Array[untyped] items) -> void
      def initialize(items = [])
        @items = items
        freeze
      end

      # Iterate over items
      #: () { (untyped) -> void } -> void
      def each(&)
        @items.each(&)
      end

      # Get the number of items
      #: () -> Integer
      def size
        @items.size
      end
      alias count size
      alias length size

      # Check if collection is empty
      #: () -> bool
      def empty?
        @items.empty?
      end

      # Get first item
      #: () -> untyped
      def first
        @items.first
      end

      # Get last item
      #: () -> untyped
      def last
        @items.last
      end

      # Convert to array
      #: () -> Array[untyped]
      def to_a
        @items.dup
      end
    end
  end
end

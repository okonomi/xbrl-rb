# frozen_string_literal: true

module Xbrl
  module Collections
    # Base collection class providing Enumerable functionality
    class BaseCollection
      include Enumerable

      # @param items [Array] Collection items
      def initialize(items = [])
        @items = items
        freeze
      end

      # Iterate over items
      # @yield [Object] Each item in the collection
      def each(&)
        @items.each(&)
      end

      # Get the number of items
      # @return [Integer]
      def size
        @items.size
      end
      alias count size
      alias length size

      # Check if collection is empty
      # @return [Boolean]
      def empty?
        @items.empty?
      end

      # Get first item
      # @return [Object, nil]
      def first
        @items.first
      end

      # Get last item
      # @return [Object, nil]
      def last
        @items.last
      end

      # Convert to array
      # @return [Array]
      def to_a
        @items.dup
      end
    end
  end
end

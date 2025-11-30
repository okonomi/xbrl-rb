# frozen_string_literal: true

module XBRL
  # XBRL namespace constants and helpers
  module Namespace
    # Standard XBRL namespaces
    XBRL_INSTANCE = "http://www.xbrl.org/2003/instance"
    LINK = "http://www.xbrl.org/2003/linkbase"
    XLINK = "http://www.w3.org/1999/xlink"
    ISO4217 = "http://www.xbrl.org/2003/iso4217"

    # EDINET specific namespaces
    EDINET_BASE = "http://disclosure.edinet-fsa.go.jp"

    # Strip namespace prefix from element name
    # @param element_name [String] Element name with or without namespace prefix
    # @return [String] Element name without namespace prefix
    # @example
    #   strip_namespace("jpcrp:NetSales") #=> "NetSales"
    #   strip_namespace("context") #=> "context"
    def self.strip_namespace(element_name)
      element_name.to_s.split(":").last
    end

    # Extract namespace prefix from element name
    # @param element_name [String] Element name with or without namespace prefix
    # @return [String, nil] Namespace prefix or nil if no prefix
    # @example
    #   extract_prefix("jpcrp:NetSales") #=> "jpcrp"
    #   extract_prefix("context") #=> nil
    def self.extract_prefix(element_name)
      parts = element_name.to_s.split(":")
      parts.length > 1 ? parts.first : nil
    end
  end
end

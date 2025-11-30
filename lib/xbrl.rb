# frozen_string_literal: true

require_relative "xbrl/version"

# Core
require_relative "xbrl/errors"
require_relative "xbrl/namespace"

# Models
require_relative "xbrl/models/context"
require_relative "xbrl/models/unit"
require_relative "xbrl/models/fact"
require_relative "xbrl/models/schema_ref"
require_relative "xbrl/models/footnote"
require_relative "xbrl/models/dimension"

# Collections
require_relative "xbrl/collections/base_collection"
require_relative "xbrl/collections/context_collection"
require_relative "xbrl/collections/unit_collection"
require_relative "xbrl/collections/fact_collection"

# Parser and Document
require_relative "xbrl/parser"
require_relative "xbrl/document"

# XBRL parser for Ruby
#
# This module provides functionality for parsing XBRL (eXtensible Business Reporting Language)
# instance documents with a focus on Japanese financial reporting formats (EDINET/TDnet).
#
# @example Parse an XBRL document
#   doc = Xbrl::Document.parse("path/to/instance.xml")
#   doc.facts.each { |fact| puts "#{fact.name}: #{fact.value}" }
module Xbrl
end

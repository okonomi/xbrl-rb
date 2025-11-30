# frozen_string_literal: true

require_relative "rb/version"

# Core
require_relative "errors"
require_relative "namespace"

# Models
require_relative "models/context"
require_relative "models/unit"
require_relative "models/fact"
require_relative "models/schema_ref"
require_relative "models/footnote"

# Collections
require_relative "collections/base_collection"
require_relative "collections/context_collection"
require_relative "collections/unit_collection"
require_relative "collections/fact_collection"

# Parser and Document
require_relative "parser"
require_relative "document"

module Xbrl
  # Internal module for gem version and metadata
  module Rb
    # Maintained for backward compatibility
  end
end

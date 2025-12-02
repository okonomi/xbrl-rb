# xbrl-rb

[![Ruby CI](https://github.com/okonomi/xbrl-rb/actions/workflows/main.yml/badge.svg)](https://github.com/okonomi/xbrl-rb/actions/workflows/main.yml)

A Ruby gem for parsing XBRL (eXtensible Business Reporting Language) instance documents, with a focus on Japanese financial reporting formats (EDINET/TDnet).

## Features

- Parse XBRL instance documents (.xml/.xbrl)
- Extract contexts (periods, entities, dimensions)
- Extract units (currencies, shares, pure numbers)
- Extract facts with full attribute support
- Parse schema references and footnotes
- Full dimension support (explicit and typed)
- Rich collection APIs with query methods
- Simple, Ruby-idiomatic API
- Support for Japanese EDINET/TDnet formats
- Fast parsing with Ox

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xbrl-rb'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install xbrl-rb
```

## Usage

### Basic Usage

```ruby
require "xbrl"

# Parse an XBRL document from a file
doc = XBRL.parse("path/to/instance.xml")

# Or parse from a string
xml_string = File.read("path/to/instance.xml")
doc = XBRL.parse_string(xml_string)
```

### Working with Contexts

```ruby
# Get all contexts (returns a ContextCollection)
doc.contexts.each do |context|
  puts "Context ID: #{context.id}"
  puts "Entity: #{context.entity_id}"
  puts "Period Type: #{context.period_type}"

  if context.duration?
    puts "Duration: #{context.start_date} to #{context.end_date}"
  elsif context.instant?
    puts "Instant: #{context.instant_date}"
  end
end

# Find a specific context by ID
context = doc.find_context("CurrentYearDuration")

# Collection query methods
instant_contexts = doc.contexts.instant
duration_contexts = doc.contexts.duration
entity_contexts = doc.contexts.find_by_entity("E12345")

# Working with dimensions
contexts_with_dims = doc.contexts.with_dimensions
segment_contexts = doc.contexts.find_by_dimension("Segment", "Japan")

# Check if context has dimensions
if context.dimensions?
  puts "Dimensions:"
  context.dimension_names.each do |dim_name|
    dim = context.dimension(dim_name)
    puts "  #{dim.qualified_name}: #{dim.value} (#{dim.type})"
  end
end
```

### Working with Units

```ruby
# Get all units (returns a UnitCollection)
doc.units.each do |unit|
  puts "Unit ID: #{unit.id}"
  puts "Measure: #{unit.measure}"
  puts "Is currency? #{unit.currency?}"
  puts "Is shares? #{unit.shares?}"
end

# Find a specific unit by ID
unit = doc.find_unit("JPY")
puts "Currency: #{unit.currency?}"  # => true

# Collection query methods
currencies = doc.units.currencies
share_units = doc.units.shares
pure_units = doc.units.pure
```

### Working with Facts

```ruby
# Get all facts
doc.facts.each do |fact|
  puts "#{fact.qualified_name}: #{fact.value}"
end

# Find facts by name
net_sales = doc.facts.find_by_name("NetSales")
net_sales.each do |fact|
  puts "#{fact.context_ref}: #{fact.to_i}"
end

# Get numeric facts only
numeric_facts = doc.facts.numeric
numeric_facts.each do |fact|
  puts "#{fact.name}: #{fact.to_i} #{fact.unit_ref}"
end

# Query facts by context
current_year_facts = doc.facts.find_by_context("CurrentYearDuration")

# Group facts by name
grouped = doc.facts.group_by_name
grouped["NetSales"].each { |fact| puts fact.value }
```

### Working with Schema References

```ruby
# Get all schema references
doc.schema_refs.each do |schema_ref|
  puts "Schema: #{schema_ref.href}"
  puts "Type: #{schema_ref.type}"
end
```

### Working with Footnotes

```ruby
# Get all footnotes
doc.footnotes.each do |footnote|
  puts "Footnote ID: #{footnote.id}"
  puts "Text: #{footnote.text}"
  puts "Language: #{footnote.lang}"
end

# Find a specific footnote by ID
footnote = doc.find_footnote("footnote1")
puts footnote.to_s
```

### Example with EDINET Data

```ruby
doc = XBRL.parse("edinet_document.xml")

# Find current year duration context
current_year = doc.contexts.duration.find { |ctx| ctx.id.include?("CurrentYear") }
puts "Current fiscal year: #{current_year.start_date} to #{current_year.end_date}"

# Get net sales for current year
net_sales = doc.facts.find_by_name("NetSales")
                      .find { |f| f.context_ref == current_year.id }
puts "Net Sales: #{net_sales.to_i} JPY"

# Get all financial facts
financial_facts = doc.facts.numeric
puts "Total financial data points: #{financial_facts.size}"
```

## Current Status

This gem is currently in development (v0.4.0) and supports:

- ✅ Context parsing (duration and instant periods)
- ✅ Unit parsing (simple units and ratios)
- ✅ Fact parsing with full attribute support
- ✅ Context, Unit, and Fact collections with query methods
- ✅ Type conversions (to_i, to_f, to_s)
- ✅ Numeric vs text fact detection
- ✅ Schema reference parsing
- ✅ Footnote parsing
- ✅ Dimension support (explicit and typed dimensions)
- ✅ Dimension parsing from segment and scenario
- ✅ Context collection dimension filtering

## Roadmap

### v0.5.0 - Label and Presentation Support
- Label parsing from linkbase files
- Presentation structure parsing
- Calculation linkbase support
- Multi-language label support

### v1.0.0 - Production Ready
- Comprehensive EDINET format support
- Performance optimizations for large documents
- Full documentation and examples
- Validation and error reporting
- Formula and assertion support

## Requirements

- Ruby >= 3.1.0

## Dependencies

- [ox](https://github.com/ohler55/ox) - Fast XML parser

## Development

### Setup

```bash
git clone https://github.com/okonomi/xbrl-rb.git
cd xbrl-rb
bundle install
bundle exec rake dev:setup
```

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/xbrl/parser_spec.rb

# Run tests with documentation format
bundle exec rspec --format documentation
```

### Code Quality

This project uses several tools to ensure code quality:

```bash
# Run all checks (tests, rubocop, steep)
bundle exec rake check

# Individual checks
bundle exec rspec          # Run tests
bundle exec rubocop        # Check code style
bundle exec steep check    # Check types
```

### Type Checking

This project uses [Steep](https://github.com/soutaro/steep) for static type checking with RBS.

```bash
# Check types
bundle exec steep check

# Generate RBS files from inline annotations
bundle exec rake rbs:generate

# Check if RBS files are up to date
bundle exec rake rbs:check
```

Type signatures are written inline using [rbs-inline](https://github.com/soutaro/rbs-inline) annotations:

```ruby
#: (String) -> void
def example_method(arg)
  # ...
end
```

### Development Workflow

1. Create a feature branch
2. Make your changes
3. Add tests for new functionality
4. Ensure all checks pass: `bundle exec rake check`
5. Commit your changes
6. Push and create a pull request

### Releasing

To release a new version:

1. Update the version number in `lib/xbrl/version.rb`
2. Update CHANGELOG.md
3. Run `bundle exec rake check` to ensure all tests pass
4. Commit the changes
5. Create and push a git tag: `git tag v0.x.x && git push origin v0.x.x`
6. GitHub Actions will automatically build and publish the gem to RubyGems

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okonomi/xbrl-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

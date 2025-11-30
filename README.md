# xbrl-rb

A Ruby gem for parsing XBRL (eXtensible Business Reporting Language) instance documents, with a focus on Japanese financial reporting formats (EDINET/TDnet).

## Features

- Parse XBRL instance documents (.xml/.xbrl)
- Extract contexts (periods, entities, dimensions)
- Extract units (currencies, shares, pure numbers)
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
require "xbrl/rb"

# Parse an XBRL document from a file
doc = Xbrl::Document.parse("path/to/instance.xml")

# Or parse from a string
xml_string = File.read("path/to/instance.xml")
doc = Xbrl::Document.parse_string(xml_string)
```

### Working with Contexts

```ruby
# Get all contexts
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
```

### Working with Units

```ruby
# Get all units
doc.units.each do |unit|
  puts "Unit ID: #{unit.id}"
  puts "Measure: #{unit.measure}"
  puts "Is currency? #{unit.currency?}"
  puts "Is shares? #{unit.shares?}"
end

# Find a specific unit by ID
unit = doc.find_unit("JPY")
puts "Currency: #{unit.currency?}"  # => true
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

### Example with EDINET Data

```ruby
doc = Xbrl::Document.parse("edinet_document.xml")

# Find current year duration context
current_year = doc.contexts.find { |ctx| ctx.id.include?("CurrentYear") && ctx.duration? }
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

This gem is currently in development (v0.2.0) and supports:

- ✅ Context parsing (duration and instant periods)
- ✅ Unit parsing (simple units and ratios)
- ✅ Fact parsing with full attribute support
- ✅ Fact collections with query methods
- ✅ Type conversions (to_i, to_f, to_s)
- ✅ Numeric vs text fact detection
- ⏳ Schema reference parsing (coming in v0.3.0)
- ⏳ Footnote parsing (coming in v0.3.0)

## Roadmap

### v0.3.0 - Complete Instance Document Support
- Schema references
- Footnotes
- Dimension handling

### v1.0.0 - Production Ready
- Comprehensive EDINET format support
- Performance optimizations
- Full documentation

## Requirements

- Ruby >= 3.1.0

## Dependencies

- [ox](https://github.com/ohler55/ox) - Fast XML parser

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okonomi/xbrl-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

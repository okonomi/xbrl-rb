# Contributing to xbrl-rb

Thank you for your interest in contributing to xbrl-rb! This document provides guidelines and instructions for contributing.

## Getting Started

### Development Setup

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/xbrl-rb.git
   cd xbrl-rb
   ```
3. Install dependencies:
   ```bash
   bundle install
   bundle exec rake dev:setup
   ```

### Development Environment

This project uses:
- **Ruby** >= 3.1.0 (tested on 3.3 and 3.4)
- **RSpec** for testing
- **RuboCop** for code style
- **Steep** for static type checking with RBS
- **rbs-inline** for inline type annotations

## Making Changes

### Workflow

1. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bugfix-name
   ```

2. Make your changes following the [code style guidelines](#code-style)

3. Add tests for your changes:
   - All new features must include tests
   - Bug fixes should include a test that fails without the fix

4. Run all checks before committing:
   ```bash
   bundle exec rake check
   ```
   This runs:
   - RSpec tests
   - RuboCop style checks
   - Steep type checks

5. Commit your changes with a descriptive message:
   ```bash
   git commit -m "Add feature: description of your change"
   ```

6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

7. Create a Pull Request on GitHub

## Code Style

### Ruby Style Guide

This project follows the [Ruby Style Guide](https://rubystyle.guide/) enforced by RuboCop.

Run style checks:
```bash
bundle exec rubocop
```

Auto-fix issues when possible:
```bash
bundle exec rubocop -a
```

### Type Annotations

This project uses [rbs-inline](https://github.com/soutaro/rbs-inline) for type annotations.

#### Writing Type Annotations

Type annotations are written as comments using the `#:` syntax:

```ruby
# Simple method signature
#: (String) -> String
def process(input)
  input.upcase
end

# Method with optional parameters
#: (String, ?Integer) -> String
def truncate(text, length = 10)
  text[0...length]
end

# Method with keyword arguments
#: (name: String, ?age: Integer) -> Hash[Symbol, untyped]
def create_person(name:, age: nil)
  { name: name, age: age }
end

# Instance variable types
#: String
attr_reader :name

#: Array[Integer]
attr_accessor :numbers
```

#### Generating RBS Files

After adding or modifying type annotations:

```bash
# Generate RBS files
bundle exec rake rbs:generate

# Check if RBS files are up to date
bundle exec rake rbs:check
```

#### Type Checking

Run Steep to check types:

```bash
bundle exec steep check
```

Fix any type errors before submitting your PR.

## Testing

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/xbrl/parser_spec.rb

# Run specific test by line number
bundle exec rspec spec/xbrl/parser_spec.rb:42
```

### Writing Tests

- Use descriptive test names
- Follow the Arrange-Act-Assert pattern
- Test both success and failure cases
- Use shared examples for common behaviors

Example:

```ruby
RSpec.describe XBRL::Parser do
  describe "#parse_context" do
    context "when context has instant period" do
      it "returns context with instant date" do
        # Arrange
        xml = "<context>...</context>"

        # Act
        result = parser.parse_context(xml)

        # Assert
        expect(result.period_type).to eq(:instant)
        expect(result.instant_date).to eq("2024-03-31")
      end
    end
  end
end
```

## Pull Request Guidelines

### Before Submitting

- [ ] All tests pass (`bundle exec rspec`)
- [ ] Code style checks pass (`bundle exec rubocop`)
- [ ] Type checks pass (`bundle exec steep check`)
- [ ] RBS files are up to date (`bundle exec rake rbs:check`)
- [ ] New features include tests
- [ ] Public APIs include type annotations
- [ ] Code changes are documented in code comments if needed

### PR Description

Please include:
- **What**: Brief description of the change
- **Why**: Motivation for the change
- **How**: Implementation approach (if complex)
- **Testing**: How you tested the change
- **Related Issues**: Link to any related issues

### Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged

## Reporting Bugs

### Before Reporting

- Check if the bug has already been reported
- Verify the bug exists on the latest version
- Collect relevant information

### Bug Report Template

When reporting bugs, please include:

1. **Ruby version**: Output of `ruby -v`
2. **Gem version**: Version of xbrl-rb
3. **Description**: Clear description of the issue
4. **Steps to reproduce**: Minimal code to reproduce the bug
5. **Expected behavior**: What should happen
6. **Actual behavior**: What actually happens
7. **Sample XBRL file**: If possible, provide a sample file (or anonymized version)

## Feature Requests

Feature requests are welcome! Please:

1. Check if the feature has already been requested
2. Clearly describe the feature and its use case
3. Explain why this feature would be useful
4. Consider submitting a PR implementing the feature

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Focus on constructive feedback
- Accept constructive criticism gracefully
- Prioritize the community's best interests

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks
- Trolling or insulting comments
- Publishing others' private information

## Questions?

If you have questions:
- Open an issue with the "question" label
- Check existing issues and documentation

## License

By contributing to xbrl-rb, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions make this project better for everyone. Thank you for taking the time to contribute!

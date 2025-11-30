# frozen_string_literal: true

module FixtureHelper
  # Get the path to a fixture file
  # @param filename [String] Fixture filename
  # @return [String] Full path to fixture file
  def fixture_path(filename)
    File.join(__dir__, "../fixtures", filename)
  end

  # Load a fixture file content
  # @param filename [String] Fixture filename
  # @return [String] File content
  def load_fixture(filename)
    File.read(fixture_path(filename))
  end
end

# frozen_string_literal: true

RSpec.describe Xbrl::Models::SchemaRef do
  describe "#initialize" do
    it "creates a schema reference with href and type" do
      schema_ref = described_class.new(
        href: "http://example.com/taxonomy.xsd",
        type: "simple"
      )

      expect(schema_ref.href).to eq("http://example.com/taxonomy.xsd")
      expect(schema_ref.type).to eq("simple")
    end

    it "defaults type to 'simple'" do
      schema_ref = described_class.new(
        href: "http://example.com/taxonomy.xsd"
      )

      expect(schema_ref.type).to eq("simple")
    end

    it "is frozen after creation" do
      schema_ref = described_class.new(
        href: "http://example.com/taxonomy.xsd"
      )

      expect(schema_ref).to be_frozen
    end
  end
end

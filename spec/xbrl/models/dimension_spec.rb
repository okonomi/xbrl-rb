# frozen_string_literal: true

RSpec.describe XBRL::Models::Dimension do
  describe "#initialize" do
    it "creates an explicit dimension" do
      dimension = described_class.new(
        name: "Segment",
        value: "Japan",
        type: :explicit,
        namespace: "jpcrp"
      )

      expect(dimension.name).to eq("Segment")
      expect(dimension.value).to eq("Japan")
      expect(dimension.type).to eq(:explicit)
      expect(dimension.namespace).to eq("jpcrp")
    end

    it "creates a typed dimension" do
      dimension = described_class.new(
        name: "DateAxis",
        value: "2023-12-31",
        type: :typed
      )

      expect(dimension.name).to eq("DateAxis")
      expect(dimension.value).to eq("2023-12-31")
      expect(dimension.type).to eq(:typed)
    end

    it "defaults type to :explicit" do
      dimension = described_class.new(
        name: "Segment",
        value: "Japan"
      )

      expect(dimension.type).to eq(:explicit)
    end

    it "is frozen after creation" do
      dimension = described_class.new(
        name: "Segment",
        value: "Japan"
      )

      expect(dimension).to be_frozen
    end
  end

  describe "#explicit?" do
    it "returns true for explicit dimensions" do
      dimension = described_class.new(
        name: "Segment",
        value: "Japan",
        type: :explicit
      )

      expect(dimension.explicit?).to be true
    end

    it "returns false for typed dimensions" do
      dimension = described_class.new(
        name: "DateAxis",
        value: "2023-12-31",
        type: :typed
      )

      expect(dimension.explicit?).to be false
    end
  end

  describe "#typed?" do
    it "returns true for typed dimensions" do
      dimension = described_class.new(
        name: "DateAxis",
        value: "2023-12-31",
        type: :typed
      )

      expect(dimension.typed?).to be true
    end

    it "returns false for explicit dimensions" do
      dimension = described_class.new(
        name: "Segment",
        value: "Japan",
        type: :explicit
      )

      expect(dimension.typed?).to be false
    end
  end

  describe "#qualified_name" do
    it "returns qualified name with namespace" do
      dimension = described_class.new(
        name: "Segment",
        value: "Japan",
        namespace: "jpcrp"
      )

      expect(dimension.qualified_name).to eq("jpcrp:Segment")
    end

    it "returns just the name when no namespace" do
      dimension = described_class.new(
        name: "Segment",
        value: "Japan"
      )

      expect(dimension.qualified_name).to eq("Segment")
    end
  end

  describe "#qualified_value" do
    it "returns value for explicit dimensions" do
      dimension = described_class.new(
        name: "Segment",
        value: "Japan",
        type: :explicit
      )

      expect(dimension.qualified_value).to eq("Japan")
    end

    it "returns value for typed dimensions" do
      dimension = described_class.new(
        name: "DateAxis",
        value: "2023-12-31",
        type: :typed
      )

      expect(dimension.qualified_value).to eq("2023-12-31")
    end
  end
end

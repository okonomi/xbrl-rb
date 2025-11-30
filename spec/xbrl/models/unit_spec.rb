# frozen_string_literal: true

RSpec.describe Xbrl::Models::Unit do
  describe "#initialize" do
    it "creates a simple unit" do
      unit = described_class.new(
        id: "JPY",
        measures: ["iso4217:JPY"]
      )

      expect(unit.id).to eq("JPY")
      expect(unit.measures).to eq(["iso4217:JPY"])
      expect(unit.divide_measures).to be_empty
    end

    it "creates a ratio unit" do
      unit = described_class.new(
        id: "ratio1",
        measures: ["numerator"],
        divide_measures: ["denominator"]
      )

      expect(unit.measures).to eq(["numerator"])
      expect(unit.divide_measures).to eq(["denominator"])
    end

    it "is frozen after creation" do
      unit = described_class.new(
        id: "JPY",
        measures: ["iso4217:JPY"]
      )

      expect(unit).to be_frozen
    end
  end

  describe "#measure" do
    it "returns the first measure" do
      unit = described_class.new(
        id: "JPY",
        measures: ["iso4217:JPY", "other"]
      )

      expect(unit.measure).to eq("iso4217:JPY")
    end

    it "returns nil for empty measures" do
      unit = described_class.new(
        id: "empty",
        measures: []
      )

      expect(unit.measure).to be_nil
    end
  end

  describe "#currency?" do
    it "returns true for ISO4217 currencies" do
      unit = described_class.new(
        id: "JPY",
        measures: ["iso4217:JPY"]
      )

      expect(unit.currency?).to be true
    end

    it "returns true for three-letter currency codes" do
      unit = described_class.new(
        id: "USD",
        measures: ["USD"]
      )

      expect(unit.currency?).to be true
    end

    it "returns false for non-currency units" do
      unit = described_class.new(
        id: "shares",
        measures: ["shares"]
      )

      expect(unit.currency?).to be false
    end
  end

  describe "#shares?" do
    it "returns true for shares units" do
      unit = described_class.new(
        id: "shares",
        measures: ["shares"]
      )

      expect(unit.shares?).to be true
    end

    it "returns false for non-shares units" do
      unit = described_class.new(
        id: "JPY",
        measures: ["iso4217:JPY"]
      )

      expect(unit.shares?).to be false
    end
  end

  describe "#pure?" do
    it "returns true for pure units" do
      unit = described_class.new(
        id: "pure",
        measures: ["pure"]
      )

      expect(unit.pure?).to be true
    end

    it "returns false for non-pure units" do
      unit = described_class.new(
        id: "JPY",
        measures: ["iso4217:JPY"]
      )

      expect(unit.pure?).to be false
    end
  end

  describe "#ratio?" do
    it "returns true for ratio units" do
      unit = described_class.new(
        id: "ratio1",
        measures: ["numerator"],
        divide_measures: ["denominator"]
      )

      expect(unit.ratio?).to be true
    end

    it "returns false for non-ratio units" do
      unit = described_class.new(
        id: "JPY",
        measures: ["iso4217:JPY"]
      )

      expect(unit.ratio?).to be false
    end
  end
end

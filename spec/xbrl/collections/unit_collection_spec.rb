# frozen_string_literal: true

RSpec.describe Xbrl::Collections::UnitCollection do
  let(:unit1) do
    Xbrl::Models::Unit.new(
      id: "JPY",
      measures: ["iso4217:JPY"]
    )
  end

  let(:unit2) do
    Xbrl::Models::Unit.new(
      id: "USD",
      measures: ["iso4217:USD"]
    )
  end

  let(:unit3) do
    Xbrl::Models::Unit.new(
      id: "shares",
      measures: ["xbrli:shares"]
    )
  end

  let(:unit4) do
    Xbrl::Models::Unit.new(
      id: "pure",
      measures: ["xbrli:pure"]
    )
  end

  let(:collection) { described_class.new([unit1, unit2, unit3, unit4]) }

  describe "#find_by_id" do
    it "finds unit by ID" do
      result = collection.find_by_id("JPY")
      expect(result).to eq(unit1)
    end

    it "returns nil when no match" do
      result = collection.find_by_id("nonexistent")
      expect(result).to be_nil
    end
  end

  describe "#currencies" do
    it "returns only currency units" do
      results = collection.currencies
      expect(results.size).to eq(2)
      expect(results).to all(be_currency)
    end
  end

  describe "#shares" do
    it "returns only share units" do
      results = collection.shares
      expect(results.size).to eq(1)
      expect(results.first).to be_shares
    end
  end

  describe "#pure" do
    it "returns only pure units" do
      results = collection.pure
      expect(results.size).to eq(1)
      expect(results.first).to be_pure
    end
  end

  describe "#find_by_measure" do
    it "finds units by measure" do
      results = collection.find_by_measure("iso4217:JPY")
      expect(results.size).to eq(1)
      expect(results.first).to eq(unit1)
    end

    it "returns empty array when no match" do
      results = collection.find_by_measure("nonexistent")
      expect(results).to be_empty
    end
  end

  describe "#measures" do
    it "returns unique measures" do
      measures = collection.measures
      expect(measures).to contain_exactly("iso4217:JPY", "iso4217:USD", "xbrli:shares", "xbrli:pure")
    end
  end

  describe "#group_by_measure" do
    it "groups units by measure" do
      grouped = collection.group_by_measure
      expect(grouped["iso4217:JPY"].size).to eq(1)
      expect(grouped["xbrli:shares"].size).to eq(1)
    end
  end

  describe "Enumerable methods" do
    it "supports each" do
      count = 0
      collection.each { |_unit| count += 1 }
      expect(count).to eq(4)
    end

    it "supports size" do
      expect(collection.size).to eq(4)
    end
  end
end

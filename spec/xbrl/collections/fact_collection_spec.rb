# frozen_string_literal: true

RSpec.describe Xbrl::Collections::FactCollection do
  let(:fact1) do
    Xbrl::Models::Fact.new(
      name: "NetSales",
      value: "1000000000",
      context_ref: "CurrentYear",
      namespace: "jpcrp",
      unit_ref: "JPY"
    )
  end

  let(:fact2) do
    Xbrl::Models::Fact.new(
      name: "NetSales",
      value: "950000000",
      context_ref: "PriorYear",
      namespace: "jpcrp",
      unit_ref: "JPY"
    )
  end

  let(:fact3) do
    Xbrl::Models::Fact.new(
      name: "CompanyName",
      value: "Test Company",
      context_ref: "CurrentYear",
      namespace: "jpcrp"
    )
  end

  let(:collection) { described_class.new([fact1, fact2, fact3]) }

  describe "#find_by_name" do
    it "finds facts by name" do
      results = collection.find_by_name("NetSales")
      expect(results.size).to eq(2)
      expect(results).to all(be_a(Xbrl::Models::Fact))
    end

    it "returns empty array when no match" do
      results = collection.find_by_name("NonExistent")
      expect(results).to be_empty
    end
  end

  describe "#find_by_context" do
    it "finds facts by context reference" do
      results = collection.find_by_context("CurrentYear")
      expect(results.size).to eq(2)
    end
  end

  describe "#find_by_unit" do
    it "finds facts by unit reference" do
      results = collection.find_by_unit("JPY")
      expect(results.size).to eq(2)
    end
  end

  describe "#find_by_namespace" do
    it "finds facts by namespace" do
      results = collection.find_by_namespace("jpcrp")
      expect(results.size).to eq(3)
    end
  end

  describe "#numeric" do
    it "returns only numeric facts" do
      results = collection.numeric
      expect(results.size).to eq(2)
      expect(results).to all(be_numeric)
    end
  end

  describe "#text" do
    it "returns only text facts" do
      results = collection.text
      expect(results.size).to eq(1)
      expect(results.first).not_to be_numeric
    end
  end

  describe "#group_by_name" do
    it "groups facts by name" do
      grouped = collection.group_by_name
      expect(grouped["NetSales"].size).to eq(2)
      expect(grouped["CompanyName"].size).to eq(1)
    end
  end

  describe "#group_by_context" do
    it "groups facts by context" do
      grouped = collection.group_by_context
      expect(grouped["CurrentYear"].size).to eq(2)
      expect(grouped["PriorYear"].size).to eq(1)
    end
  end

  describe "#names" do
    it "returns unique fact names" do
      names = collection.names
      expect(names).to contain_exactly("NetSales", "CompanyName")
    end
  end

  describe "Enumerable methods" do
    it "supports each" do
      count = 0
      collection.each { |_fact| count += 1 }
      expect(count).to eq(3)
    end

    it "supports select" do
      results = collection.select { |f| f.name == "NetSales" }
      expect(results.size).to eq(2)
    end

    it "supports map" do
      names = collection.map(&:name)
      expect(names).to eq(%w[NetSales NetSales CompanyName])
    end
  end

  describe "#size" do
    it "returns the number of facts" do
      expect(collection.size).to eq(3)
    end
  end

  describe "#empty?" do
    it "returns false for non-empty collection" do
      expect(collection.empty?).to be false
    end

    it "returns true for empty collection" do
      empty = described_class.new([])
      expect(empty.empty?).to be true
    end
  end
end

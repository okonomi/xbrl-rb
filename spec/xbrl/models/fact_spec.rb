# frozen_string_literal: true

RSpec.describe XBRL::Models::Fact do
  describe "#initialize" do
    it "creates a numeric fact" do
      fact = described_class.new(
        name: "NetSales",
        value: "1000000000",
        context_ref: "ctx1",
        namespace: "jpcrp",
        unit_ref: "JPY",
        decimals: "-6"
      )

      expect(fact.name).to eq("NetSales")
      expect(fact.value).to eq("1000000000")
      expect(fact.context_ref).to eq("ctx1")
      expect(fact.namespace).to eq("jpcrp")
      expect(fact.unit_ref).to eq("JPY")
      expect(fact.decimals).to eq("-6")
    end

    it "creates a text fact" do
      fact = described_class.new(
        name: "CompanyName",
        value: "Test Company",
        context_ref: "ctx1",
        namespace: "jpcrp"
      )

      expect(fact.name).to eq("CompanyName")
      expect(fact.value).to eq("Test Company")
      expect(fact.unit_ref).to be_nil
    end

    it "is frozen after creation" do
      fact = described_class.new(
        name: "Test",
        value: "value",
        context_ref: "ctx1",
        namespace: "test"
      )

      expect(fact).to be_frozen
    end
  end

  describe "#numeric?" do
    it "returns true for numeric facts with unit" do
      fact = described_class.new(
        name: "NetSales",
        value: "1000000000",
        context_ref: "ctx1",
        namespace: "jpcrp",
        unit_ref: "JPY"
      )

      expect(fact.numeric?).to be true
    end

    it "returns false for text facts" do
      fact = described_class.new(
        name: "CompanyName",
        value: "Test Company",
        context_ref: "ctx1",
        namespace: "jpcrp"
      )

      expect(fact.numeric?).to be false
    end

    it "returns false when unit_ref is missing" do
      fact = described_class.new(
        name: "Test",
        value: "123",
        context_ref: "ctx1",
        namespace: "test"
      )

      expect(fact.numeric?).to be false
    end
  end

  describe "#to_i" do
    it "converts numeric fact to integer" do
      fact = described_class.new(
        name: "NetSales",
        value: "1000000000",
        context_ref: "ctx1",
        namespace: "jpcrp",
        unit_ref: "JPY"
      )

      expect(fact.to_i).to eq(1_000_000_000)
    end

    it "returns nil for non-numeric facts" do
      fact = described_class.new(
        name: "CompanyName",
        value: "Test Company",
        context_ref: "ctx1",
        namespace: "jpcrp"
      )

      expect(fact.to_i).to be_nil
    end
  end

  describe "#to_f" do
    it "converts numeric fact to float" do
      fact = described_class.new(
        name: "Ratio",
        value: "3.14",
        context_ref: "ctx1",
        namespace: "jpcrp",
        unit_ref: "pure"
      )

      expect(fact.to_f).to eq(3.14)
    end

    it "returns nil for non-numeric facts" do
      fact = described_class.new(
        name: "CompanyName",
        value: "Test Company",
        context_ref: "ctx1",
        namespace: "jpcrp"
      )

      expect(fact.to_f).to be_nil
    end
  end

  describe "#to_s" do
    it "returns the value as string" do
      fact = described_class.new(
        name: "Test",
        value: "123",
        context_ref: "ctx1",
        namespace: "test"
      )

      expect(fact.to_s).to eq("123")
    end
  end

  describe "#qualified_name" do
    it "returns qualified name with namespace" do
      fact = described_class.new(
        name: "NetSales",
        value: "1000000000",
        context_ref: "ctx1",
        namespace: "jpcrp",
        unit_ref: "JPY"
      )

      expect(fact.qualified_name).to eq("jpcrp:NetSales")
    end

    it "returns just the name when no namespace" do
      fact = described_class.new(
        name: "Test",
        value: "value",
        context_ref: "ctx1",
        namespace: nil
      )

      expect(fact.qualified_name).to eq("Test")
    end
  end
end

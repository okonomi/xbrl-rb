# frozen_string_literal: true

RSpec.describe XBRL::Document do
  describe "#contexts" do
    let(:doc) { XBRL.parse(fixture_path("simple_instance.xml")) }

    it "returns a ContextCollection" do
      expect(doc.contexts).to be_a(XBRL::Collections::ContextCollection)
    end

    it "returns all contexts" do
      expect(doc.contexts.size).to eq(3)
    end

    it "parses context attributes correctly" do
      context = doc.contexts.first
      expect(context).to be_a(XBRL::Models::Context)
      expect(context.id).to eq("CurrentYearDuration")
      expect(context.entity_id).to eq("E12345-001")
      expect(context.entity_scheme).to eq("http://disclosure.edinet-fsa.go.jp")
    end

    it "parses duration periods" do
      context = doc.find_context("CurrentYearDuration")
      expect(context.period_type).to eq(:duration)
      expect(context.duration?).to be true
      expect(context.instant?).to be false
      expect(context.start_date).to eq(Date.new(2023, 4, 1))
      expect(context.end_date).to eq(Date.new(2024, 3, 31))
    end

    it "parses instant periods" do
      context = doc.find_context("CurrentYearInstant")
      expect(context.period_type).to eq(:instant)
      expect(context.instant?).to be true
      expect(context.duration?).to be false
      expect(context.instant_date).to eq(Date.new(2024, 3, 31))
    end
  end

  describe "#units" do
    let(:doc) { XBRL.parse(fixture_path("simple_instance.xml")) }

    it "returns a UnitCollection" do
      expect(doc.units).to be_a(XBRL::Collections::UnitCollection)
    end

    it "returns all units" do
      expect(doc.units.size).to eq(3)
    end

    it "parses unit attributes correctly" do
      unit = doc.find_unit("JPY")
      expect(unit).to be_a(XBRL::Models::Unit)
      expect(unit.id).to eq("JPY")
      expect(unit.measure).to eq("iso4217:JPY")
    end

    it "identifies currency units" do
      unit = doc.find_unit("JPY")
      expect(unit.currency?).to be true
      expect(unit.shares?).to be false
      expect(unit.pure?).to be false
    end

    it "identifies shares units" do
      unit = doc.find_unit("shares")
      expect(unit.shares?).to be true
      expect(unit.currency?).to be false
    end

    it "identifies pure units" do
      unit = doc.find_unit("pure")
      expect(unit.pure?).to be true
      expect(unit.currency?).to be false
    end
  end

  describe "#find_context" do
    let(:doc) { XBRL.parse(fixture_path("simple_instance.xml")) }

    it "finds a context by ID" do
      context = doc.find_context("CurrentYearDuration")
      expect(context).not_to be_nil
      expect(context.id).to eq("CurrentYearDuration")
    end

    it "returns nil for non-existent context" do
      context = doc.find_context("NonExistent")
      expect(context).to be_nil
    end
  end

  describe "#find_unit" do
    let(:doc) { XBRL.parse(fixture_path("simple_instance.xml")) }

    it "finds a unit by ID" do
      unit = doc.find_unit("JPY")
      expect(unit).not_to be_nil
      expect(unit.id).to eq("JPY")
    end

    it "returns nil for non-existent unit" do
      unit = doc.find_unit("NonExistent")
      expect(unit).to be_nil
    end
  end

  describe "#facts" do
    let(:doc) { XBRL.parse(fixture_path("simple_instance.xml")) }

    it "returns a FactCollection" do
      expect(doc.facts).to be_a(XBRL::Collections::FactCollection)
    end

    it "parses all facts from the document" do
      expect(doc.facts.size).to eq(3)
    end

    it "parses fact attributes correctly" do
      net_sales = doc.facts.find_by_name("NetSales").first
      expect(net_sales).to be_a(XBRL::Models::Fact)
      expect(net_sales.name).to eq("NetSales")
      expect(net_sales.namespace).to eq("jpcrp")
      expect(net_sales.context_ref).to eq("CurrentYearDuration")
      expect(net_sales.unit_ref).to eq("JPY")
      expect(net_sales.decimals).to eq("-6")
    end

    it "identifies numeric facts" do
      net_sales = doc.facts.find_by_name("NetSales").first
      expect(net_sales.numeric?).to be true
      expect(net_sales.to_i).to eq(1_000_000_000)
    end

    it "supports querying by name" do
      net_sales_facts = doc.facts.find_by_name("NetSales")
      expect(net_sales_facts.size).to eq(2)
    end

    it "supports querying by context" do
      current_year_facts = doc.facts.find_by_context("CurrentYearDuration")
      expect(current_year_facts.size).to eq(1)
    end

    it "supports filtering numeric facts" do
      numeric_facts = doc.facts.numeric
      expect(numeric_facts.size).to eq(3)
      expect(numeric_facts).to all(be_numeric)
    end
  end
end

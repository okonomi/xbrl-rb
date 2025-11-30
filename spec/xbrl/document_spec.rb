# frozen_string_literal: true

RSpec.describe Xbrl::Document do
  describe ".parse" do
    it "parses a simple XBRL instance document" do
      doc = described_class.parse(fixture_path("simple_instance.xml"))

      expect(doc).to be_a(Xbrl::Document)
      expect(doc.contexts).not_to be_empty
      expect(doc.units).not_to be_empty
    end

    it "raises an error for non-existent files" do
      expect do
        described_class.parse("nonexistent.xml")
      end.to raise_error(Xbrl::InvalidDocumentError, /File not found/)
    end
  end

  describe ".parse_string" do
    it "parses XBRL from a string" do
      xml = load_fixture("simple_instance.xml")
      doc = described_class.parse_string(xml)

      expect(doc).to be_a(Xbrl::Document)
      expect(doc.contexts).not_to be_empty
      expect(doc.units).not_to be_empty
    end

    it "raises an error for invalid XML" do
      expect do
        described_class.parse_string("<invalid>")
      end.to raise_error(Xbrl::ParseError)
    end
  end

  describe "#contexts" do
    let(:doc) { described_class.parse(fixture_path("simple_instance.xml")) }

    it "returns all contexts" do
      expect(doc.contexts.size).to eq(3)
    end

    it "parses context attributes correctly" do
      context = doc.contexts.first
      expect(context).to be_a(Xbrl::Models::Context)
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
    let(:doc) { described_class.parse(fixture_path("simple_instance.xml")) }

    it "returns all units" do
      expect(doc.units.size).to eq(3)
    end

    it "parses unit attributes correctly" do
      unit = doc.find_unit("JPY")
      expect(unit).to be_a(Xbrl::Models::Unit)
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
    let(:doc) { described_class.parse(fixture_path("simple_instance.xml")) }

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
    let(:doc) { described_class.parse(fixture_path("simple_instance.xml")) }

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
end

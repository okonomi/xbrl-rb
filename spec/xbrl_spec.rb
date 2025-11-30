# frozen_string_literal: true

RSpec.describe XBRL do
  it "has a version number" do
    expect(XBRL::VERSION).not_to be_nil
  end

  describe ".parse" do
    it "parses a simple XBRL instance document" do
      doc = XBRL.parse(fixture_path("simple_instance.xml"))
      expect(doc).to be_a(XBRL::Document)
      expect(doc.contexts.size).to eq(3)
      expect(doc.units.size).to eq(3)
      expect(doc.facts.size).to eq(3)
    end

    it "raises an error for non-existent files" do
      expect do
        XBRL.parse("nonexistent.xml")
      end.to raise_error(XBRL::InvalidDocumentError, /File not found/)
    end
  end

  describe ".parse_string" do
    it "parses XBRL from a string" do
      xml = File.read(fixture_path("simple_instance.xml"))
      doc = XBRL.parse_string(xml)
      expect(doc).to be_a(XBRL::Document)
    end

    it "raises an error for invalid XML" do
      expect do
        XBRL.parse_string("<invalid>")
      end.to raise_error(XBRL::InvalidDocumentError)
    end
  end
end

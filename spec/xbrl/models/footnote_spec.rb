# frozen_string_literal: true

RSpec.describe XBRL::Models::Footnote do
  describe "#initialize" do
    it "creates a footnote with id, text, and language" do
      footnote = described_class.new(
        id: "footnote1",
        text: "This is a footnote",
        lang: "en"
      )

      expect(footnote.id).to eq("footnote1")
      expect(footnote.text).to eq("This is a footnote")
      expect(footnote.lang).to eq("en")
    end

    it "allows nil language" do
      footnote = described_class.new(
        id: "footnote1",
        text: "This is a footnote"
      )

      expect(footnote.lang).to be_nil
    end

    it "is frozen after creation" do
      footnote = described_class.new(
        id: "footnote1",
        text: "This is a footnote"
      )

      expect(footnote).to be_frozen
    end
  end

  describe "#language?" do
    it "returns true when language matches" do
      footnote = described_class.new(
        id: "footnote1",
        text: "This is a footnote",
        lang: "en"
      )

      expect(footnote.language?("en")).to be true
    end

    it "returns false when language does not match" do
      footnote = described_class.new(
        id: "footnote1",
        text: "This is a footnote",
        lang: "en"
      )

      expect(footnote.language?("ja")).to be false
    end

    it "returns false when language is nil" do
      footnote = described_class.new(
        id: "footnote1",
        text: "This is a footnote"
      )

      expect(footnote.language?("en")).to be false
    end
  end

  describe "#to_s" do
    it "returns the text" do
      footnote = described_class.new(
        id: "footnote1",
        text: "This is a footnote"
      )

      expect(footnote.to_s).to eq("This is a footnote")
    end
  end
end

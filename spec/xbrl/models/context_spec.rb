# frozen_string_literal: true

RSpec.describe Xbrl::Models::Context do
  describe "#initialize" do
    it "creates a duration context" do
      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :duration,
        start_date: "2023-01-01",
        end_date: "2023-12-31"
      )

      expect(context.id).to eq("ctx1")
      expect(context.entity_scheme).to eq("http://example.com")
      expect(context.entity_id).to eq("E12345")
      expect(context.period_type).to eq(:duration)
      expect(context.start_date).to eq(Date.new(2023, 1, 1))
      expect(context.end_date).to eq(Date.new(2023, 12, 31))
      expect(context.instant_date).to be_nil
    end

    it "creates an instant context" do
      context = described_class.new(
        id: "ctx2",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        instant_date: "2023-12-31"
      )

      expect(context.period_type).to eq(:instant)
      expect(context.instant_date).to eq(Date.new(2023, 12, 31))
      expect(context.start_date).to be_nil
      expect(context.end_date).to be_nil
    end

    it "is frozen after creation" do
      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :duration
      )

      expect(context).to be_frozen
    end
  end

  describe "#duration?" do
    it "returns true for duration periods" do
      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :duration
      )

      expect(context.duration?).to be true
      expect(context.instant?).to be false
    end
  end

  describe "#instant?" do
    it "returns true for instant periods" do
      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant
      )

      expect(context.instant?).to be true
      expect(context.duration?).to be false
    end
  end
end

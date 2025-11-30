# frozen_string_literal: true

RSpec.describe XBRL::Models::Context do
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

  describe "#dimensions?" do
    it "returns true when context has dimensions" do
      segment_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan"
      )

      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        dimensions: { "Segment" => segment_dim }
      )

      expect(context.dimensions?).to be true
    end

    it "returns false when context has no dimensions" do
      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant
      )

      expect(context.dimensions?).to be false
    end
  end

  describe "#dimension" do
    it "returns dimension by name" do
      segment_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan"
      )

      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        dimensions: { "Segment" => segment_dim }
      )

      expect(context.dimension("Segment")).to eq(segment_dim)
    end

    it "returns nil for non-existent dimension" do
      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant
      )

      expect(context.dimension("Segment")).to be_nil
    end
  end

  describe "#dimension_names" do
    it "returns all dimension names" do
      segment_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan"
      )
      region_dim = XBRL::Models::Dimension.new(
        name: "Region",
        value: "Tokyo"
      )

      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        dimensions: { "Segment" => segment_dim, "Region" => region_dim }
      )

      expect(context.dimension_names).to contain_exactly("Segment", "Region")
    end
  end

  describe "#explicit_dimensions" do
    it "returns only explicit dimensions" do
      explicit_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan",
        type: :explicit
      )
      typed_dim = XBRL::Models::Dimension.new(
        name: "Date",
        value: "2023-12-31",
        type: :typed
      )

      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        dimensions: { "Segment" => explicit_dim, "Date" => typed_dim }
      )

      expect(context.explicit_dimensions.size).to eq(1)
      expect(context.explicit_dimensions["Segment"]).to eq(explicit_dim)
    end
  end

  describe "#typed_dimensions" do
    it "returns only typed dimensions" do
      explicit_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan",
        type: :explicit
      )
      typed_dim = XBRL::Models::Dimension.new(
        name: "Date",
        value: "2023-12-31",
        type: :typed
      )

      context = described_class.new(
        id: "ctx1",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        dimensions: { "Segment" => explicit_dim, "Date" => typed_dim }
      )

      expect(context.typed_dimensions.size).to eq(1)
      expect(context.typed_dimensions["Date"]).to eq(typed_dim)
    end
  end
end

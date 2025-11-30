# frozen_string_literal: true

RSpec.describe XBRL::Collections::ContextCollection do
  let(:context1) do
    XBRL::Models::Context.new(
      id: "ctx1",
      entity_scheme: "http://example.com",
      entity_id: "E12345",
      period_type: :instant,
      instant_date: "2023-12-31"
    )
  end

  let(:context2) do
    XBRL::Models::Context.new(
      id: "ctx2",
      entity_scheme: "http://example.com",
      entity_id: "E12345",
      period_type: :duration,
      start_date: "2023-01-01",
      end_date: "2023-12-31"
    )
  end

  let(:context3) do
    XBRL::Models::Context.new(
      id: "ctx3",
      entity_scheme: "http://example.com",
      entity_id: "E67890",
      period_type: :instant,
      instant_date: "2023-12-31"
    )
  end

  let(:collection) { described_class.new([context1, context2, context3]) }

  describe "#find_by_id" do
    it "finds context by ID" do
      result = collection.find_by_id("ctx1")
      expect(result).to eq(context1)
    end

    it "returns nil when no match" do
      result = collection.find_by_id("nonexistent")
      expect(result).to be_nil
    end
  end

  describe "#instant" do
    it "returns only instant contexts" do
      results = collection.instant
      expect(results.size).to eq(2)
      expect(results).to all(be_instant)
    end
  end

  describe "#duration" do
    it "returns only duration contexts" do
      results = collection.duration
      expect(results.size).to eq(1)
      expect(results).to all(be_duration)
    end
  end

  describe "#find_by_entity" do
    it "finds contexts by entity identifier" do
      results = collection.find_by_entity("E12345")
      expect(results.size).to eq(2)
      expect(results).to include(context1, context2)
    end

    it "returns empty array when no match" do
      results = collection.find_by_entity("nonexistent")
      expect(results).to be_empty
    end
  end

  describe "#entity_identifiers" do
    it "returns unique entity identifiers" do
      identifiers = collection.entity_identifiers
      expect(identifiers).to contain_exactly("E12345", "E67890")
    end
  end

  describe "#group_by_entity" do
    it "groups contexts by entity identifier" do
      grouped = collection.group_by_entity
      expect(grouped["E12345"].size).to eq(2)
      expect(grouped["E67890"].size).to eq(1)
    end
  end

  describe "#with_dimensions" do
    it "returns contexts with dimensions" do
      segment_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan"
      )

      context_with_dim = XBRL::Models::Context.new(
        id: "ctx4",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        instant_date: "2023-12-31",
        dimensions: { "Segment" => segment_dim }
      )

      collection_with_dims = described_class.new([context1, context_with_dim])
      results = collection_with_dims.with_dimensions

      expect(results.size).to eq(1)
      expect(results.first).to eq(context_with_dim)
    end
  end

  describe "#without_dimensions" do
    it "returns contexts without dimensions" do
      segment_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan"
      )

      context_with_dim = XBRL::Models::Context.new(
        id: "ctx4",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        instant_date: "2023-12-31",
        dimensions: { "Segment" => segment_dim }
      )

      collection_with_dims = described_class.new([context1, context_with_dim])
      results = collection_with_dims.without_dimensions

      expect(results.size).to eq(1)
      expect(results.first).to eq(context1)
    end
  end

  describe "#find_by_dimension" do
    it "finds contexts by dimension name and value" do
      segment_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan"
      )

      context_with_dim = XBRL::Models::Context.new(
        id: "ctx4",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        instant_date: "2023-12-31",
        dimensions: { "Segment" => segment_dim }
      )

      collection_with_dims = described_class.new([context1, context_with_dim])
      results = collection_with_dims.find_by_dimension("Segment", "Japan")

      expect(results.size).to eq(1)
      expect(results.first).to eq(context_with_dim)
    end

    it "finds contexts by dimension name only" do
      segment_dim = XBRL::Models::Dimension.new(
        name: "Segment",
        value: "Japan"
      )

      context_with_dim = XBRL::Models::Context.new(
        id: "ctx4",
        entity_scheme: "http://example.com",
        entity_id: "E12345",
        period_type: :instant,
        instant_date: "2023-12-31",
        dimensions: { "Segment" => segment_dim }
      )

      collection_with_dims = described_class.new([context1, context_with_dim])
      results = collection_with_dims.find_by_dimension("Segment")

      expect(results.size).to eq(1)
      expect(results.first).to eq(context_with_dim)
    end
  end

  describe "Enumerable methods" do
    it "supports each" do
      count = 0
      collection.each { |_ctx| count += 1 }
      expect(count).to eq(3)
    end

    it "supports size" do
      expect(collection.size).to eq(3)
    end
  end
end

require_relative "../schemas/order"

describe Order do
  context "validating example payload" do
    subject { described_class.new.call load_json "payload" }
    it { expect(subject.success?).to be true }
  end

  describe "#to_internal_api" do
    subject do
      order = described_class.new.call load_json "payload"
      described_class.to_internal_api(order)
    end

    it "generates a valid payload" do
      is_expected.to eq load_json "processed"
    end
  end
end

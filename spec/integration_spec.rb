require "rack/app/test"

require_relative "../app"
require_relative "../database"

describe DeliveryApp do
  include Rack::App::Test
  rack_app described_class

  describe "/" do
    before do
      stub_request(:post, ENV["DELIVERY_CENTER_API_URL"])
        .to_return(status: 200)
    end
    subject { post("/", headers: {"Content-Type": "application/json"}, payload: load_json("payload").to_json) }

    it "returns correct HTTP code" do
      expect(subject.status).to eq 201
    end

    it "sends correct payload to API" do
      subject
      expect(WebMock).to have_requested(:post, ENV["DELIVERY_CENTER_API_URL"])
        .with(body: load_json("processed").to_json)
    end

    it "sets the X-Sent header" do
      allow(DateTime).to receive(:now).and_return DateTime.new(2019, 10, 24, 9, 25, 0)
      subject
      expect(WebMock).to have_requested(:post, ENV["DELIVERY_CENTER_API_URL"])
        .with(headers: {"X-Sent": "09h25 - 24/10/19"})
    end

    it "saves original order to database" do
      collection = Database.new.collection
      expect { subject }.to change { collection.count }.by 1
    end
  end
end

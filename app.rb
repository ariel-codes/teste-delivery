require "json"
require "uri"
require "net/http"

require_relative "errors"
require_relative "schemas/order"
require_relative "database"

class DeliveryApp < Rack::App
  database = Database.new

  post "/" do
    original_payload = Order.new.call JSON.parse! payload
    raise APIFormatError.new original_payload.errors(full: true) unless original_payload.success?

    processed_payload = Order.to_internal_api original_payload

    res = Net::HTTP.post URI(ENV["DELIVERY_CENTER_API_URL"]),
      processed_payload.to_h.to_json,
      "Content-Type": "application/json",
      "X-Sent": DateTime.now.strftime("%Hh%M - %d/%m/%y")
    raise APIGatewayError.new(res.code) unless res.is_a?(Net::HTTPSuccess)

    database.insert original_payload.to_h
    response.status = 201
  end

  error JSON::ParserError, APIFormatError do |error|
    response.status = 400
    error.to_s if error.is_a? APIFormatError
  end

  error APIGatewayError do |error|
    response.status = 502
    error.to_s
  end
end

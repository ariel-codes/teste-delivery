class APIError < StandardError
  def initialize(errors)
    super({errors: errors.to_h}.to_json)
  end
end

class APIFormatError < APIError; end

class APIGatewayError < APIError
  def initialize(code)
    super({gateway: "Gateway returned HTTP code #{code}"})
  end
end

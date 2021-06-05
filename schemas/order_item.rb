class OrderItem < Dry::Schema::JSON
  define do
    required(:item).hash do
      required(:id).filled(:string)
      required(:title).filled(:string)
    end
    required(:quantity).filled(:integer)
    required(:unit_price).filled(:float)
    required(:full_unit_price).filled(:float)
  end

  def self.to_internal_api(payload)
    {
      externalCode: payload.dig(:item, :id),
      name: payload.dig(:item, :title),
      price: payload[:unit_price],
      quantity: payload[:quantity],
      total: (payload[:unit_price] * payload[:quantity]),
      subItems: []
    }
  end
end

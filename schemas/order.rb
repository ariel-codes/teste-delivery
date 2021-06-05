require_relative "translatable_schema"
require_relative "order_item"
require_relative "payment"
require_relative "shipping"
require_relative "buyer"

class Order < TranslatableSchema
  define do
    required(:id).filled(:integer)
    required(:store_id).filled(:integer)
    required(:date_created).filled(:date_time)
    required(:date_closed).filled(:date_time)
    required(:last_updated).filled(:date_time)
    required(:total_amount).filled(:float)
    required(:total_shipping).filled(:float)
    required(:total_amount_with_shipping).filled(:float)
    required(:paid_amount).filled(:float)
    required(:expiration_date).filled(:date_time)
    required(:order_items).value(:array).each(OrderItem.new)
    required(:payments).value(:array).each(Payment.new)
    required(:shipping).hash(Shipping.new)
    required(:status).filled(:string)
    required(:buyer).hash(Buyer.new)
  end

  def self.money(value)
    format("%.2f", value)
  end

  def self.to_internal_api(payload)
    {
      externalCode: payload[:id].to_s,
      storeId: payload[:store_id],
      subTotal: money(payload[:total_amount]),
      deliveryFee: money(payload[:total_shipping]),
      total_shipping: payload[:total_shipping],
      total: money(payload[:total_amount_with_shipping]),
      country: "BR",
      state: "SP",
      city: "Cidade de Testes",
      district: "Bairro Fake",
      street: "Rua de Testes Fake",
      complement: "galpao",
      latitude: -23.629037,
      longitude: -46.712689,
      dtOrderCreate: "2019-06-27T19:59:08.251Z",
      postalCode: "85045020",
      number: "0",
      customer: Buyer.to_internal_api(payload[:buyer]),
      items: payload[:order_items].map { |item| OrderItem.to_internal_api(item) },
      payments: payload[:payments].map { |payment| Payment.to_internal_api(payment) }
    }
  end
end

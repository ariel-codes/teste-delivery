class Payment < Dry::Schema::JSON
  define do
    required(:id).filled(:integer)
    required(:order_id).filled(:integer)
    required(:payer_id).filled(:integer)
    required(:installments).filled(:integer)
    required(:payment_type).filled(:string)
    required(:status).filled(:string)
    required(:transaction_amount).filled(:float)
    required(:taxes_amount).filled(:integer)
    required(:shipping_cost).filled(:float)
    required(:total_paid_amount).filled(:float)
    required(:installment_amount).filled(:float)
    required(:date_approved).filled(:date_time)
    required(:date_created).filled(:date_time)
  end

  def self.to_internal_api(payload)
    {
      type: payload[:payment_type].upcase,
      value: payload[:total_paid_amount]
    }
  end
end

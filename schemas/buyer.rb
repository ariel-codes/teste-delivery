require_relative "translatable_schema"

class Buyer < TranslatableSchema
  define do
    required(:id).filled(:integer)
    required(:nickname).filled(:string)
    required(:email).filled(:string)
    required(:phone).hash do
      required(:area_code).filled(:integer)
      required(:number).filled(:string)
    end
    required(:first_name).filled(:string)
    required(:last_name).filled(:string)
    required(:billing_info).hash do
      required(:doc_type).filled(:string)
      required(:doc_number).filled(:string)
    end
  end

  def self.to_internal_api(payload)
    {
      externalCode: payload[:id].to_s,
      name: payload[:nickname],
      email: payload[:email],
      contact: payload.dig(:phone, :area_code).to_s + payload.dig(:phone, :number)
    }
  end
end

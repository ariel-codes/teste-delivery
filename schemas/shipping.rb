class Shipping < Dry::Schema::JSON
  define do
    required(:id).filled(:integer)
    required(:shipment_type).filled(:string)
    required(:date_created).filled(:date_time)
    required(:receiver_address).hash do
      required(:id).filled(:integer)
      required(:address_line).filled(:string)
      required(:street_name).filled(:string)
      required(:street_number).filled(:string)
      required(:comment).filled(:string)
      required(:zip_code).filled(:string)
      required(:city).hash do
        required(:name).filled(:string)
      end
      required(:state).hash do
        required(:name).filled(:string)
      end
      required(:country).hash do
        required(:id).filled(:string)
        required(:name).filled(:string)
      end
      required(:neighborhood).hash do
        required(:id).maybe(:string)
        required(:name).filled(:string)
      end
      required(:latitude).filled(:float)
      required(:longitude).filled(:float)
      required(:receiver_phone).filled(:string)
    end
  end
end

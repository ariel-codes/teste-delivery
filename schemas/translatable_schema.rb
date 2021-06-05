class TranslatableSchema < Dry::Schema::JSON
  def self.to_internal_api(payload)
    raise NotImplementedError
  end
end

class Database
  attr_accessor :collection

  def initialize
    @client = Mongo::Client.new ENV["DATABASE_URL"]
    @collection = @client[:orsders]
  end

  def insert(data)
    @collection.insert_one data
  end
end

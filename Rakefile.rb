# Very ugly code, just a quick hack for one-time run
desc "Generate dry-schema for a json file"
task :generate_schema, %i[json classname] do |_, args|
  require "json"
  json_hash = JSON.parse File.read(File.join(Dir.pwd, args[:json]))
  output_file = File.new File.join(__dir__, "schemas", args[:classname] + ".rb"), "w"
  output_file << <<~RUBY.chomp
    class #{args[:classname].capitalize} < Dry::Schema::JSON
      define do
  RUBY

  def extract_attributes(hash)
    hash.each_with_object({}) do |(key, value), obj|
      type = case value
                 when Integer
                   :integer
                 when TrueClass, FalseClass
                   :boolean
                 when Float
                   :float
                 when NilClass
                   nil
                 when Hash
                   extract_attributes(hash[key])
                 when Array
                   [extract_attributes(hash[key].first)] unless hash[key].empty?
                 when /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}([-+]\d{2}:\d{2}|Z)$/
                   :date_time
                 else
                   :string
      end
      obj[key] = type
    end
  end

  def define_attributes(attrs, output, level = 2)
    attrs.map do |att, type|
      output << "\n#{"  " * level}required(#{att.to_sym.inspect})."
      case type
      when Hash
        output << "hash do"
        define_attributes type, output, level + 1
      when Array
        output << "array(:hash) do"
        define_attributes type.first, output, level + 1
      when nil
        output << "maybe(:string)"
      else
        output << "filled(#{type.to_sym.inspect})"
      end
      if type.is_a?(Array) || type.is_a?(Hash)
        output << "\n#{"  " * level}end"
      end
    end
  end

  define_attributes(extract_attributes(json_hash), output_file)
  output_file << "\n  end\nend\n"
end

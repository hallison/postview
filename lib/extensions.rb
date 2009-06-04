class Hash
  def symbolize_keys
    self.inject({}) do |hash, (key, value)|
      hash[key.to_sym] = if value.kind_of? Hash
                           value.symbolize_keys
                         else
                           value
                         end
      hash
    end
  end

  def instance_variables_set_to(object)
    collect do |variable, value|
      object.instance_variable_set("@#{variable}", value) if object.respond_to? variable
    end
    object
  end
end

class Array
  def limit(size)
    self[0..size]
  end
end


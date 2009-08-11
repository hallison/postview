class Array
  # Count objects in elements.
  def count(obj = nil)
    if block_given?
      select { |item| yield item }.size
    else
      select { |item| item == obj }.size
    end
  end
end


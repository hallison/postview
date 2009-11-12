class Array

  # Returns elements between first and the specific limit.
  def limit(size)
    self[0..size - 1]
  end

end

class String

  # Clean all spaces, non-words and digits.
  def clean
    gsub(/[ \W\d]/,'').downcase
  end

end

class Symbol

  # Check other symbol for sort methods.
  def <=>(symbol)
    to_s <=> symbol.to_s
  end

end


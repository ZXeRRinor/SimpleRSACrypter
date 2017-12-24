class Encrypt_key #keys_generator
  def initialize(p, q, e)
    @p = p
    @q = q
    @e = e
    self.calculate_n(p, q)
  end

  def calculate_n(p, q)
    p * q
  end

  def calculate_fi(p, q)
    self.calculate_n(p, q) - p - q + 1
  end

  def calculate_d(e, fi)
    d = 1
    while (d * e) % fi != 1
      d += 1
    end
    return(d)
  end

  def generate_key
    a = Array.new(2, nil)
    a[0] = self.calculate_n(@p, @q)
    a[1] = @e
    return(a)
  end

  def to_a
    self.generate_key
  end
end

class Decrypt_key < Encrypt_key
  def generate_key
    a = Array.new(2, nil)
    a[0] = self.calculate_n(@p, @q)
    a[1] = self.calculate_d(@e, self.calculate_fi(@p, @q))
    return(a)
  end
end
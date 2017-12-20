class Encrypt_key
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

puts('Please enter P, Q and E: ')
p = gets.to_i
q = gets.to_i
e = gets.to_i

encrypt_key = Encrypt_key.new(p, q, e)
decrypt_key = Decrypt_key.new(p, q, e)

puts('Encrypt key: ')
p(encrypt_key.to_a)
puts('Decrypt key: ')
p(decrypt_key.to_a)
class MultiSystemNumber
  def initialize(number, system_base = 10)
    @number = number
    @system_base = system_base
  end
  def to_dec
    result = 0
    @number.to_s.split('').reverse.each_with_index do |elem, index|
      result += elem.to_i * @system_base ** index.to_i
    end
    return result
  end
  def to_dec!
    @number = self.to_dec
    @system_base = 10
    @number
  end
  def from_dec_to_system(system_base, number = @number)
    result = Array.new
    res = number
    while res != 0
      result.push(res % system_base)
      res = (res - res % system_base) / system_base
    end
    return result.reverse
  end
  def from_dec_to_system!(system_base)
    @number = self.from_dec_to_system(system_base)
    @system_base = system_base
  end
  def to_system(system_base)
    self.from_dec_to_system(system_base, to_dec)
  end
  def to_system!(system_base)
    @number = self.from_dec_to_system(system_base, to_dec)
    @system_base = system_base
  end
end

num = MultiSystemNumber.new(773,10)
#p num.from_dec_to_system(16)
p num.to_system(37)
p num
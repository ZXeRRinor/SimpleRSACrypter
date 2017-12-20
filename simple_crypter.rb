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
#keys_generator
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
#calcsystem_trans
module RSACryptable #module_for_String
  def set_code_table
    @code_table = ['а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я', ' ', '.', ',', '!']
  end

  def manual_set_code_table
    @code_table.map! do
      puts('Please enter symbol: ')
      gets().to_s
    end
  end

  def in_power_mod(num, power, mod)
    #squares = power - power % 2
    #for i in 0..squares
    #end
    num ** power % mod
  end

  def split_by(splitter)
    inp = self.split('')
    flag = 0
    last_elems = Array.new
    result = Array.new
    inp.each do |elem|
      last_elems.push(elem)
      #p last_elems
      flag += 1
      if flag == splitter
        result.push(last_elems.clone)
        last_elems.clear
        flag = 0
      end
    end
    #p result
    #p result.length
    preparing_arr = Array.new
    if result[-1][-1] != inp[-1]
      #inp[inp.find_index(result[-1][-1]) + 1..inp.length - 1].each do |elem|
      #  preparing_arr.push(elem)
      #end
      #p result.flatten.length
      inp[result.flatten.length..inp.length - 1].each do |elem|
        preparing_arr.push(elem)
      end
      #(splitter - inp[inp.find_index(result[-1][-1])..inp.length - 1].length + 1).times do
      #  preparing_arr.push(' ')
      #end #for unfilled
      (splitter - inp[result.flatten.length..inp.length - 1].length).times do
        preparing_arr.push(' ')
      end #for unfilled
      result.push(preparing_arr)
    end
    #p result
    return result
  end

  def to_number(split_size)
    str = self.split_by(split_size)
    nums = str.map do |elem|
      elem.map do |el|
        #p @code_table.find_index(el)
        #p el
        @code_table.find_index(el)
      end
    end
    #p ' nums '
    #p nums
    nums.map! do |elem|
      x = 0
      elem.reverse.each_with_index do |el, key|
        #p el * @code_table.length ** key
        x += el * @code_table.length ** key
      end
      x
    end
    #nums.map! do |elem|
    #  p elem
    #  num = MultiSystemNumber.new(elem.to_i, 37) #number of chars in code table = 37
    #  p num
    #  num.to_dec!
    #  num.number
    #end
    #p nums
    return nums
  end

  def rsa_encrypt
    #if self.length % 2 == 1
    #  self.split().push(' ').to_s
    #end
    split_size = 2 #need to create autodetection of size of grammes (split_size)
    self.downcase
    self.set_code_table
    #p self.to_number(split_size)
    encrypted = self.to_number(split_size).map do |elem|
      #p elem
      #p encrypt_key[1]
      #p encrypt_key[0]
      #in_power_mod(elem, encrypt_key[1], encrypt_key[0])
      #p in_power_mod(elem, encrypt_key[1], encrypt_key[0])
      #p MultiSystemNumber.new(in_power_mod(elem, @encrypt_key[1], @encrypt_key[0])).to_system(@code_table.length)
      MultiSystemNumber.new(in_power_mod(elem, @encrypt_key[1], @encrypt_key[0])).to_system(@code_table.length)
    end
    #p encrypted
    encrypted.map! do |elem|
      if elem.length < 3 #3-grammes
        elem.unshift(0)
      else
        elem
      end
    end
    encrypted.map! do |elem|
      elem.map! do |elem|
        @code_table[elem]
      end
    end
    return encrypted.join
  end

  def preparing_to_decrypt #invalid! need to be rewrited
    power_binary = MultiSystemNumber.new(@decrypt_key[1], 10).to_system(2)
    #p power_binary
    #p self
    #p self.split_by(3)
    pre_result = self.to_number(3).join.to_i
    #p pre_result
    #p power_binary
    power_binary_in = power_binary
    power_binary_in.pop
    m_res = power_binary_in.map() do | | # what about "power_binary.length - 1.times"-way?
      pre_result = pre_result ** 2 % @decrypt_key[0]
    end
    result = 1
    m_res.reverse!.push(self.to_number(3).join.to_i).reverse!
    #p m_res
    m_res.each_with_index() do |elem, key|
      p elem
      #p power_binary[key]
      if (power_binary.reverse[key] == 1) && (key != 0)
        #p elem
        result *= (elem * power_binary.reverse[key])
      end
      #if key == 0
      #  p 'pre res'
      #  result *= self.to_number(3).join.to_i
        #p result
      #end
    end

    #p result
    return result % @decrypt_key[0]
  end

  def rsa_decrypt
    split_size = 3 #need to create autodetection of size of grammes (split_size)
    decrypted = self.to_number(split_size).map do |elem|
      #p elem
      #p encrypt_key[1]
      #p encrypt_key[0]
      #in_power_mod(elem, encrypt_key[1], encrypt_key[0])
      #p in_power_mod(elem, encrypt_key[1], encrypt_key[0])
      #p MultiSystemNumber.new(in_power_mod(elem, @encrypt_key[1], @encrypt_key[0])).to_system(@code_table.length)
      MultiSystemNumber.new(in_power_mod(elem, @decrypt_key[1], @decrypt_key[0])).to_system(@code_table.length)
    end
    decrypted.map! do |elem|
      elem.map! do |elem|
        @code_table[elem]
      end
    end
    return decrypted.join
  end

  def rsa_decrypt_uw(p, q, e) #approximately useless...
    self.set_code_table
    self.generate_keys(p, q, e)
    d = @decrypt_key[1]
    #p d
    split_size = 3 # AUTODECTION!!!! LET'S CREATE AUTODECTION METHOD!!
    d_binary = MultiSystemNumber.new(d, 10).to_system(2)
    #p d_binary
    #d_binary_reversed = d_binary.reverse
    #p self.to_number(3)
    prenum = 1

    decrypted = self.to_number(split_size).map do |elem|
      #p 'elem'
      #p elem
      d_binary.reverse.each_with_index do |el, key|
        #p el
        #p key
        #p 'supernumber'
        c = (elem ** key * el) % @code_table.length
        #p c
        if el != 0 #or c != 0 ?
          #p 'in if'
          #p el
          #p c
          prenum *= c
        end
      end
      #p 'prenum'
      #p prenum % @code_table.length
      prenum % @code_table.length
    end
    decrypted.map! do |elem|
      @code_table[elem]
    end
    #p decrypted
    return decrypted #.join
  end #approximately useless...

  def generate_keys(p, q, e)
    @encrypt_key = Encrypt_key.new(p, q, e).to_a
    @decrypt_key = Decrypt_key.new(p, q, e).to_a
    return @encrypt_key, @decrypt_key
  end

end

#module_for_String

String.include(RSACryptable)
#str = 'я учу дискретную математику'
str = 'дмитрий'
str.set_code_table
str.generate_keys(61, 47, 29)

#str = 'абажъ'
#str = 'я учу дискретную математику'
#r = 'ауахтацёамааодажсакчалтадхаёёаёсаёёаоэажс'
#str = gets().chomp!
p str.decrypt
#p str.split_by(3)
#r = 'дмитрий'
puts '  b'
r = str.prep_2_way.to_s
#p r
#p r.class
#r = 'бде' # костыли...
r.set_code_table
r.generate_keys(61, 47, 29) # костыли ends
p r.rsa_encrypt
#MultiSystemNumber.new(str.preparing_to_decrypt).to_system(37)
#p MultiSystemNumber.new(723).to_system(37)

#tests
#1]
# p = 59 q = 61 e = 31
# input = вфн (2 21 14)
# output = ту (723(at decimal))
#2]
# p =
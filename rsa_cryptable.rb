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
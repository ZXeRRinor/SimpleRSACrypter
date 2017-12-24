module PrimeNumberProcessor
  def prime_numbers(lim)
    nums = (2..lim).to_a #preparing
    nums.each do |elem|
      nums.delete_if {|i| (i > elem) && ((i % elem) == 0)}
    end
    nums
  end

  def is_prime?(num)
    i = 2
    flag = true
    while i < (num / 2)
      if num % i == 0
        flag = false
        puts(i)
        break
      end
      i += 1
    end
    flag
  end
end
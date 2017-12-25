module PrimeNumberProcessor
  def prime_numbers_generator(from = 2,to)
    nums = (2..to).to_a #preparing
    nums = nums.partition() {|num| num % 2 == 0}[1]
    nums.each do |elem|
      nums.delete_if {|i| (i > elem) && ((i % elem) == 0)}
    end
    nums.unshift(2)
    nums.select() {|elem| (elem >= from) && (elem <= to)}
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

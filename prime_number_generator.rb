module PrimeNumberProcessor
  def prime_numbers(lim)
    nums = (2..lim).to_a #preparing
    nums.each do |elem|
      nums.delete_if {|i| (i > elem) && ((i % elem) == 0)}
    end
    nums
  end
end
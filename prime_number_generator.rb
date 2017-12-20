def prime_numbers(lim)
  nums = Array.new()
  p = 0
  (2..lim + 1).each() do |elem|
    nums.push(elem)
  end

  return nums
end
p prime_numbers(10)
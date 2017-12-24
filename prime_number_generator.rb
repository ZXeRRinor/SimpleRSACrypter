include Math
def prime_numbers(lim)
  nums = Array.new() #preparing
  (2..lim + 1).each() do |elem|
    nums.push(true)
  end
  x = 3
  last_num = 3
  while last_num < sqrt(lim.to_i)
    while x < lim #algorithm
      x += 2 * last_num
      if nums[x]
        nums[x] = false
      end
    end
    i = 1
    until nums[last_num + 2 * i]
      p nums[last_num + 2 * i]
      p last_num
      last_num += 1
    end
  end
  return nums
end

prime_numbers(30).each_with_index do |elem, key|
  #p elem
  #p key
  if !elem
    p key
  end
end
puts('Please enter number: ')
num = gets.to_i

module Tester
  def is_prime?(num)
    i = 2
    flag = 1
    while i < (num / 2)
      if num % i == 0
        flag = 0
        puts(i)
        break
      end
      i += 1
    end

    if flag == 1
      puts(num.to_s + ' is prime number')
    else
      puts(num.to_s + ' is not prime number')
    end
  end
end
Object.include(Tester)
is_prime?(num)
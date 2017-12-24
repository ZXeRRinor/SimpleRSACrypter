load 'rsa_cryptable.rb'
load 'multi_system_number.rb'
load 'rsa_keys_generator.rb'
String.include(RSACryptable)
#str = 'я учу дискретную математику'

str = 'строка'
str.set_code_table
str.generate_keys(61, 47, 29)

#str = 'абажъ'
#str = 'я учу дискретную математику'
#r = 'ауахтацёамааодажсакчалтадхаёёаёсаёёаоэажс'
#str = gets().chomp!
#p str.decrypt
#p str.split_by(3)
#r = 'дмитрий'
puts '  b'
r = str.rsa_decrypt.to_s
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
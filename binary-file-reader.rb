#!/usr/bin/env ruby

require 'awesome_print'
require 'bindata'
require './itch-message.rb'

itch_file = ARGF.read
i = 1
c = 1
n = 1
len = ''
data = ''

itch_file.each_byte do |b|
  while i <= 2
    len << b
    i += 1
    break
  end
 
  next if i <= 2
  if i == 3
    i += 1
    next
  end

  msg_len = len.unpack('n').join.to_i
  
  while c <= msg_len
    data << b
    c += 1
    break
  end 
  
  next if c <= msg_len 
  
  payload = Itch::ItchMessage.read(data)
  ap payload, :indent => 2

  # reset vars
  i = 1
  c = 1
  len = ''
  data = ''
  
  break if n == 5 
  n +=1
end

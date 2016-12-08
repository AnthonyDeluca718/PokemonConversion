

move_list = File.new("move_list.txt", 'r')

moves = []

move_list.each_line do |line|
  words = line.split
  moves.push(words[1..-1].join(" "))
end

move_list.close

(0..10).each do |i|
  puts moves[i]
end

class Pokemon

  attr_accessor :species, :moves, :nick, :gender, :nature, :evs, :ivs, :ability, :item

end

pikachu = Pokemon.new

pikachu.species = pikachu

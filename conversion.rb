
#moves

move_list = File.new("move_list.txt", 'r')

moves = []

move_list.each_line do |line|
  words = line.split
  moves.push(words[1..-1].join(" "))
end

#abilities

ability_list = File.new("ability_list.txt", 'r')

abilities = []

ability_list.each_line do |line|
  words = line.split
  abilities.push(words[1..-1].join(" "))
end

#natures

nature_list = File.new("nature_list.txt", 'r')

natures = []

nature_list.each_line do |line|
  words = line.split
  natures.push(words[1..-1].join(" "))
end

#items

item_list = File.new("item_list.txt", 'r')

items = []

item_list.each_line do |line|
  words = line.split
  items.push(words[1..-1].join(" "))
end

#Pokemon - Pokemon is a hash not an array

pokemon_list = File.new("pokemon_list.txt", 'r')

mons = {}

pokemon_list.each_line do |line|
  words = line.split
  mons[words[0]] = words[1..-1].join(" ")
end



class Pokemon

  attr_accessor :species, :moves, :nick, :gender, :nature, :evs, :dvs, :ability, :item

  def initialize
    @moves = []
    @evs = []
    @dvs = []
  end

  def dup
    new_poke = Pokemon.new

    new_poke.species = self.species
    new_poke.nick = self.nick
    new_poke.gender = self.gender
    new_poke.nature = self.nature
    new_poke.ability = self.ability
    new_poke.item = self.item

    new_poke.moves = self.moves.dup
    new_poke.evs = self.evs.dup
    new_poke.dvs = self.evs.dup

    return new_poke

  end

end


def team(file_name, moves, mons, items, abilities, natures)

  file = File.new(file_name)


  pokemon = []


  file.each_line do |line|

    line.lstrip!

    words = line.split(/[<,>, ]/)

    case words[1]
    when "Pokemon"

      # :species, :moves, :nick, :gender, :nature, :evs, :dvs, :ability, :item

      pokemon.push(Pokemon.new)

      first = (words[2] =~ /[\"]/)
      forme = words[2][(first+1)...-1].to_i
      first = (words[3] =~ /[\"]/)
      num = words[3][(first+1)...-1].to_i
      pokemon.last.species = mons["#{num}:#{forme}"]


      first = (words[4] =~ /[\"]/)
      pokemon.last.nick = words[4][(first+1)...-1]




    when "/Pokemon"
      puts "end poke"
    when "Move"
      pokemon.last.moves.push(moves[words[2].to_i])
    when "EV"
      pokemon.last.evs.push(words[2])
    when "DV"
      pokemon.last.dvs.push(words[2])
    end

  end

  file.close

  return pokemon

end

pokes = team("articuno_team", moves, mons, items, abilities, natures)

pokes.each do |poke|

  puts poke.species
  puts poke.nick
  p poke.evs
  p poke.dvs

  poke.moves.each do |move|
    puts move
  end

end


#moves

# https://github.com/po-devs/pokemon-online/blob/master/bin/db/moves/moves.txt

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
  items[words[0].to_i] = words[1..-1].join(" ")
end

berry_list = File.new("berry_list.txt", 'r')

berries = {}

berry_list.each_line do |line|
  words = line.split
  berries[words[0].to_i] = words[1..-1].join(" ")
end

#Pokemon - Pokemon is a hash not an array

pokemon_list = File.new("pokemon_list.txt", 'r')

mons = {}

pokemon_list.each_line do |line|
  words = line.split
  mons[words[0]] = words[1..-1].join(" ")
end



class Pokemon

  attr_accessor :species, :moves, :nick, :gender, :nature, :evs, :dvs, :ability, :item, :happiness, :shiny

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


def team(file_name, moves, mons, items, abilities, natures, berries)

  file = File.new(file_name)

  pokemon = []
  gen = []

  file.each_line do |line|

    line.lstrip!

    words = line.split(/[<,>, ]/)

    case words[1]
    when "Team"
      data = words.join(" ")
      start = (data =~ / gen=/)
      gen.push(data[start+6])
    when "Pokemon"

      # :species, :moves, :nick, :gender, :nature, :evs, :dvs, :ability, :item, :happiness, :shiny

      #<Pokemon Forme="0" Num="227" Nickname="Skarmory" Happiness="0" Gen="3" Shiny="0" Item="15" Ability="51" Gender="1" Lvl="100" SubGen="4" Nature="8">

      pokemon.push(Pokemon.new)

      num = "0"
      forme = "0"
      words[2...-1].each do |equals_str|
        stuff = equals_str.split("=")
        key = stuff[0]

        if stuff[1]
          val = stuff[1]
          val = val.tr("\"", '')
        end

        case key
        when "Forme"
          forme = val.to_i
        when "Num"
          num = val.to_i
        when "Nickname"
          pokemon.last.nick = val
        when "Happiness"
          pokemon.last.happiness = val
        when "Shiny"
          pokemon.last.shiny = val
        when "Item"
          if val.to_i > 8000
            pokemon.last.item = berries[val.to_i - 7999]
          else
            pokemon.last.item = items[val.to_i]
          end
        when "Ability"
          pokemon.last.ability = abilities[val.to_i]
        when "Gender"
          pokemon.last.gender = val
        when "Nature"
          pokemon.last.nature = natures[val.to_i]
        end

      end

      if forme != 0

        case num
        when 201, 351, 412, 421, 422, 423, 585, 586, 647, 649, 666, 669, 670, 671, 676
          pokemon.last.species = mons["#{num}:#{forme}:A"]
        when 386, 487, 492, 551, 555, 641, 642, 645, 648, 681, 710, 711
          pokemon.last.species = mons["#{num}:#{forme}:AD"]
        when 25, 172, 413, 479, 646, 678, 720
          pokemon.last.species = mons["#{num}:#{forme}:D"]
        end

      elsif (mons["#{num}:#{forme}"])
        pokemon.last.species = mons["#{num}:#{forme}"]
      else
        pokemon.last.species = mons["#{num}:#{forme}:H"]
      end

    when "/Pokemon"

    when "Move"
      pokemon.last.moves.push(moves[words[2].to_i])
    when "EV"
      pokemon.last.evs.push(words[2])
    when "DV"
      pokemon.last.dvs.push(words[2])
    end

  end

  file.close

  return [gen[0], pokemon]

end

# test case

# outfile = File.new("test", 'w')
# pokes = team("ADV/1", moves, mons, items, abilities, natures)
#
# pokes.each do |poke|
#
#   outfile.puts [poke.nick, "(#{poke.species})", "@", poke.item].join(" ")
#   outfile.puts ["Ability:", poke.ability].join(" ")
#
#   if (poke.shiny == 1)
#     outfile.puts "Shiny: Yes"
#   end
#
#   outfile.puts "Happiness: #{poke.happiness}"
#
#   outfile.puts ["EVs:", poke.evs[0], "HP", "/",
#     poke.evs[1], "Atk", "/",
#     poke.evs[2], "Def", "/",
#     poke.evs[3], "SpA", "/",
#     poke.evs[4], "SpD", "/",
#     poke.evs[5], "Spe" ].join(" ")
#   outfile.puts [poke.nature, "Nature"].join(" ")
#   outfile.puts ["IVs:", poke.dvs[0], "HP", "/",
#     poke.dvs[1], "Atk", "/",
#     poke.dvs[2], "Def", "/",
#     poke.dvs[3], "SpA", "/",
#     poke.dvs[4], "SpD", "/",
#     poke.dvs[5], "Spe" ].join(" ")
#   poke.moves.each do |move|
#     outfile.puts " - #{move}"
#   end
#
#   outfile.puts ""
# end


# iterating through the directory

adv = File.open("Golden_ADV", 'w')
dpp = File.open("Golden_DPP", 'w')
other = File.open("Golden_Other", 'w')

outfile = adv

dir = Dir.new("ADV")

dir.entries[2..-1].each do |entry|

  res = team("ADV/#{entry}", moves, mons, items, abilities, natures, berries)

  gen = res[0]
  pokes = res[1]

  if gen == "3"
    outfile = adv
    title = "=== [gen3ou] #{entry} ==="
  elsif gen == "4"
    outfile = dpp
    title = "=== [gen4ou] #{entry} ==="
  else
    outfile = other
    puts gen
  end

  outfile.puts(title)
  outfile.puts ""

  pokes.each do |poke|

    outfile.puts [poke.nick, "(#{poke.species})", "@", poke.item].join(" ")
    outfile.puts ["Ability:", poke.ability].join(" ")

    if (poke.shiny == 1)
      outfile.puts "Shiny: Yes"
    end

    outfile.puts "Happiness: #{poke.happiness}"

    outfile.puts ["EVs:", poke.evs[0], "HP", "/",
      poke.evs[1], "Atk", "/",
      poke.evs[2], "Def", "/",
      poke.evs[3], "SpA", "/",
      poke.evs[4], "SpD", "/",
      poke.evs[5], "Spe" ].join(" ")
    outfile.puts [poke.nature, "Nature"].join(" ")
    outfile.puts ["IVs:", poke.dvs[0], "HP", "/",
      poke.dvs[1], "Atk", "/",
      poke.dvs[2], "Def", "/",
      poke.dvs[3], "SpA", "/",
      poke.dvs[4], "SpD", "/",
      poke.dvs[5], "Spe" ].join(" ")
    poke.moves.each do |move|
      outfile.puts " - #{move}"
    end


    outfile.puts ""

  end

end

require 'nokogiri'
require 'rubygems'
require 'open-uri'
load '../Containers/pokemon.rb'
load '../Containers/ability.rb'
load '../Containers/move.rb'

overallAbilityMap = {}


class ParserAbilities
	attr_accessor :baseHTML_forDoc, :abilityName_forDoc, :allAbilitiesDoc, :abilitiesNameMap

	def initialize(args = {}) 
		@baseHTML_forDoc = "http://pokemondb.net"
		@abilityName_forDoc = "http://pokemondb.net/ability/"
		@allAbilitiesDoc = Nokogiri::HTML(open(@abilityName_forDoc))
		@abilitiesNameMap = {}
	end
	
	def parsePokemonDB()
		abilityList = @allAbilitiesDoc.css("a.ent-name")
		puts abilityList.length
		for x in 0...abilityList.length
			htmlAbilityName = abilityList[x]['href'];
			
			currentAbilityHTML = @baseHTML_forDoc + htmlAbilityName
			currentAbilityDoc = Nokogiri::HTML(open(currentAbilityHTML))
			
			#currentAbilityDoc.css("div.colset > div.col > p").text

			# args = {:name => "name", :description => "description"}
			currentAbilityArgs = {};
			currentAbilityName = currentAbilityDoc.css("article.main-content > h1").text.strip()
			# Website has " (ability)" after every ability name
			currentAbilityName = currentAbilityName[0,currentAbilityName.rindex(" ")]

			currentAbilityArgs[:name] = currentAbilityName
			currentAbilityArgs[:description] = currentAbilityDoc.css("div.colset > div.col > p")[0].text.strip()
			
			currentAbility = Ability.new(currentAbilityArgs)

			@abilitiesNameMap[htmlAbilityName] = currentAbility

			puts currentAbility

			sleep 0.5

			# puts abilityList[x][href]
		end
	end

	def to_json(fileName)
		if(@abilitiesNameMap == nil)
			return;
		end
		writeFile = File.open(fileName, "w")
		writeFile.puts("{\n")
		writeFile.puts("\t\"Abilities\":[\n")

		abilitiesNameMapKeys = @abilitiesNameMap.keys
		count = 0
		max = abilitiesNameMapKeys.length
		for currentAbilityKey in abilitiesNameMapKeys
			if(count != max-1)
				abilitiesNameStr = @abilitiesNameMap[currentAbilityKey].to_s
				abilitiesNameStr+=","
				writeFile.puts(abilitiesNameStr)
			else
				writeFile.puts(@abilitiesNameMap[currentAbilityKey].to_s)
			end
			count += 1
		end

		writeFile.puts("\t]\n")
		writeFile.puts("}")
		
		writeFile.close()
	end 
end

args = {}

test = ParserAbilities.new(args)
test.parsePokemonDB
x = test.abilitiesNameMap

# file = File.open("Abilities.txt", "w")
# abilitiesKeys = x.keys()
# for y in abilitiesKeys
# 	file.puts(x[y])
# end
test.to_json("AllAbilities.json")

file1 = File.open("AbilitiesKeys.txt", "w")
for y in abilitiesKeys
	puts y
	file1.puts(y)
end

y = x.keys

for a in x.keys
	puts a
	print x[a]
end

# page = Nokogiri::HTML(open("http://pokemondb.net/ability/"))

# puts page.css("table#abilities").text
# doc = page.css('title').text

# doc = 
#  puts doc

# .css("table class=\"dextable\"").css("tr")[1]
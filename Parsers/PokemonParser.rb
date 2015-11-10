require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'json'

load '../Containers/pokemon.rb'
load '../Containers/ability.rb'
load '../Containers/move.rb'
load '../Enum/EggGroups.rb'
load '../Utilities/PrintArray.rb'

$totalCurrentPokemon = 721
$eggEnumerator = EggGroups.new
class PokemonParser
	attr_accessor :baseHTML_forDoc, :pokemonName_forDoc, :allPokemonDoc, :pokemonNameMap,
				  :totalCurrentPokemon, :abilityNameMap, :moveNameMap

	def initialize(args = {})
		@baseHTML_forDoc = "http://pokemondb.net"
		@pokemonName_forDoc = "http://pokemondb.net/pokedex/"
		@allPokemonDoc = Nokogiri::HTML(open(@pokemonName_forDoc))
		@moveNameMap = args[:moveNameMap]
		# @totalCurrentPokemon = 721
		# @abilityNameMap = args[:abilityNameMap] || {}
		# @pokemonNameMap = args[:moveNameMap] || {}
	end

	def parsePokemonDB()
		pokemonCounter = $totalCurrentPokemon
		for dexNumber in 1...pokemonCounter
			currentPokemonHTML = @pokemonName_forDoc + dexNumber.to_s
			currentPokemonDoc = Nokogiri::HTML(open(currentPokemonHTML))

			########################################################################
			# Going to parse each pokemon one by one. 							   
			# The abilities and moves are encoded on the pages as: 				   
			#     /move/body-slam 												   
			#  	  /ability/overgrow							
			# so we are going to parse all moves/abilities first, hold 	   
			# their definition in a map, with they key being the above url. 	
			########################################################################

			###################################################################################
			# Collecting all of the data on pokemon stats: 						 			  #
			# :national_dex_number, :name, :species, :types, :abilities, :gender_threshold,   #
			# :catch_rate, :egg_groups, :hatch_counter, :height, :weight, :base_exp_yield,    # 
			# :base_friendship, :exp_group, :ev_yield, :body_style, :color, :base_stats,      #
			# :pokedexEntry_x, :pokedexEntry_y, :pokedexEntry_or, :pokedexEntry_as,           #
			# :learnSet_level_xy, :learnSet_level_oras, :learnSet_machine, :learnSet_eggMove, #
			# :learnSet_tutor, :learnSet_special,:learnSet_evolve, :learnSet_transfer         #
			###################################################################################
			pokemonArgs = {}

			##########################################################################
			# For National Dex Number: 										         #
			##########################################################################
			pokemonArgs[:national_dex_number] = pokemonCounter;
			########################################################################################
			# For type, species, height, weight, abilities, ev yield, catch rate, base friendship, #
			# base exp yield, exp group, egg groups, gender threshold, hatch counter               #
			########################################################################################
			pokemonLifeTraitsDoc = currentPokemonDoc.css('article > div.tabset-basics > 
				ul > li > div > div')
			# For types, species, height, weight, abilities
			##################################################################################
			specificStatsDoc = pokemonLifeTraitsDoc[1].css('table > tbody > tr')
			# For Types:

			# For Species:
			pokemonArgs[:species] = specificStatsDoc[2].css('td').text
			# For Height:
			heightInputStr = specificStatsDoc[3].css('td').text.split('(')
			pokemonArgs[:height] = heightInputStr[1][0,heightInputStr[1].length-1]
				# Appears as F"I (0.X M), we want the meters

			# For Abilities
			abilitiesArray = Array.new
			abilitiesListDoc = specificStatsDoc[5].css('a')
			for abilityCount in 0...abilitiesListDoc.length
				abilitiesArray.push(abilitiesListDoc[abilityCount].text)
			end
			abilitiesArrayStr = abilitiesArray.to_s
			pokemonArgs[:abilities] = abilitiesArrayStr

			# For ev yield, catch rate, base friendship, base exp yield, exp group
			##################################################################################
			specificStatsDoc = currentPokemonDoc.css('article > div.tabset-basics > 
				ul > li > div > div')
			specificStatsDoc = specificStatsDoc[2].css('div > div > table > tbody > tr')
			# For Ev Yield

			# For catch_rate
			catchRateDoc = specificStatsDoc[1].css('td')
			catchRateStr = catchRateDoc[0].text
				#enum function
			pokemonArgs[:catch_rate] = catchRateStr[0, catchRateStr.rindex("(") ]

			# For Base Happiness
			baseHappyStr = specificStatsDoc[2].text.split(' ')[2]
			pokemonArgs[:base_friendship] = baseHappyStr

			# For Base Exp
			baseExpDoc = specificStatsDoc[3].css('td')
			pokemonArgs[:base_exp_yield] =  baseExpDoc.text

			# For Growth rate
			growthRateDoc = specificStatsDoc[4].css('td')
			growthRateDoc.text
			# put into enum then into pokemon args
			#pokemonArgs[:exp_group] = toEnum(growRateDoc.text)

			# egg groups, gender threshold, hatch counter
			##################################################################################
			specificStatsDoc = currentPokemonDoc.css('article > div.tabset-basics > 
				ul > li > div > div')
			specificStatsDoc = specificStatsDoc[2].css('div > div')[1].css('table > tbody > tr')

			# For egg group
			eggDoc = specificStatsDoc[0].css('td').text.strip()
			eggArray = Array.new
			if eggDoc.include? ","
				eggList = eggDoc.split(",")
				for egg in eggList
					eggEnumInt = $eggEnumerator.switch(egg.strip())
					eggArray.push(eggEnumInt)
				end
			else
				eggArray.push(eggDoc.strip())
			end
			pokemonArgs[:egg_groups] = eggArray
			
			# For gender threshhold
			genderDoc = specificStatsDoc[1].css('td').text.strip()
			if (genderDoc == "Genderless")
				pokemonArgs[:gender_threshold] = genderDoc
			end
			genderPartition = genderDoc.split('%')
			pokemonArgs[:gender_threshold] = genderPartition[0]

			# For hatch counter 
			hatchDoc = specificStatsDoc[2].css('td').text
			hatchPartition = hatchDoc.split('(')
			pokemonArgs[:hatch_counter] = hatchPartition[0]

			# for base stats
			##################################################################################
			specificStatsDoc = currentPokemonDoc.css('article > div.tabset-basics > ul > 
				li > div')[1].css('div > table > tbody')
			baseStatArray = PrintArray.new
			for count in 0..5
				currentBaseStat = specificStatsDoc.css('tr')[count].css('td')[0].text
				baseStatArray.push(currentBaseStat)
			end

			#for moves
			################################################################################## 
			level_egg_tutor_MovesDoc = currentPokemonDoc.css('article > div.tabset-moves-game > ul')[1].css(
				'li#svtabs_moves_14 > div > div > table')

			# for level up moves
			levelUpMovesArray = Array.new
			levelUpMovesDoc = level_egg_tutor_MovesDoc[0].css(' tbody > tr')
			count = 0;
			moveNameMapKeys = @moveNameMap.keys
			for count in 0...levelUpMovesDoc.length
				levelUpMovesDoc[count].css('a.ent-name').map { | name | 
					levelUpMovesArray.push(@moveNameMap[name.text.strip()])
				}		
			end
			pokemonArgs[:learnSet_evolve] = levelUpMovesArray.to_s

			# for eggMoves
			eggMovesArray = Array.new
			eggMovesDoc = level_egg_tutor_MovesDoc[1].css('tbody > tr')
			count = 0;
			for count in 0...eggMovesDoc.length
				eggMovesDoc[count].css('a.ent-name').map { | name | 
					eggMovesArray.push(@moveNameMap[name.text.strip()])
				}		
			end
			pokemonArgs[:learnSet_eggMove] = eggMovesArray

			# for move tutor moves
			moveTutorMovesArray = Array.new
			moveTutorMovesDoc = level_egg_tutor_MovesDoc[2].css('tbody > tr')
			count = 0;
			for count in 0...moveTutorMovesDoc.length
				moveTutorMovesDoc[count].css('a.ent-name').map { | name | 
					moveTutorMovesArray.push(@moveNameMap[name.text.strip()])
				}		
			end
			pokemonArgs[:learnSet_tutor] =  moveTutorMovesArray.to_s

			#hm_tm_moves
			######

			#for hm moves
			hm_tm_MovesDoc = currentPokemonDoc.css('article > div.tabset-moves-game > ul')[1].css(
				'li#svtabs_moves_14 > div > div')[1].css('table')
			hmMovesArray = Array.new
			hm_movesDoc = hm_tm_MovesDoc[0].css('tbody > tr')
			for count in 0...hm_movesDoc.length
				hm_movesDoc.css('a.ent-name').map { | name |
					hmMovesArray.push(@moveNameMap[name.text.strip])
				}
			end
			hmMovesArray.to_s

			#for tm moves
			tmMovesArray = Array.new
			tm_MovesDoc = hm_tm_MovesDoc[1].css('tbody > tr')
			#for count in 0...tm_MovesDoc.length
				tm_MovesDoc.css('a.ent-name').map { |name | 
					tmMovesArray.push(@moveNameMap[name.text.strip()]) 
				}
				# puts tm_MovesDoc.css('a.ent-name').map { | name |
				# 	tmMovesArray.push(@moveNameMap[name.text.strip])
				# }
			#end
			pokemonArgs[:learnSet_machine] = tmMovesArray.to_s
			#puts hm_tm_MovesDoc[1].css('tbdoy > tr > a.ent-name').text

			#transfer-only moves
			#####
			transferMovesArray = Array.new
			transferMovesDoc = currentPokemonDoc.css('article > div.tabset-moves-game > ul')[1].css(
				'li#svtabs_moves_14 > div')[1].css('table > tbody > tr > td > a.ent-name')#'> tbody > tr > a.ent-name')
			transferMovesDoc.map { | name |
				transferMovesArray.push(@moveNameMap[name.text.strip()])
			}
			pokemonArgs[:learnSet_transfer] = transferMovesArray.to_s

			currentPokemonObject = Pokemon.new(pokemonArgs)
			puts
			puts "pokemon:"
			puts currentPokemonObject.to_s

			puts "---------"

			sleep 0.7
		end
		# pokemonList = @allPokemonDoc.css()
	end
end


movesFiles = File.open("AllMoves.json").read
parsedMoves = JSON.parse(movesFiles)

moveNameMapParsed = {}
count = 0
parsedMoves['Moves'].each do | move |
	moveArgs = {}
	parsedMoveName = move["Name"]
	moveArgs[:name] = parsedMoveName
	moveArgs[:type] = move["Type"]
	moveArgs[:pp] = move["PP"]
	moveArgs[:power] = move["Power"]
	moveArgs[:accuracy] = move["Accuracy"]
	moveArgs[:category] = move["Category"]
	moveArgs[:damage] = move["Damage"]
	moveArgs[:description] =  move["Description"]
	currentMove = Move.new(moveArgs)
	 #currentMove.to_s
	moveNameMapParsed[parsedMoveName] = count
	count += 1
end 

args = {}
args[:moveNameMap] = moveNameMapParsed
test = PokemonParser.new(args)

# puts test.totalCurrentPokemon
test.parsePokemonDB()

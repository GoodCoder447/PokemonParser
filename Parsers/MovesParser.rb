require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'json'
load '../Containers/pokemon.rb'
load '../Containers/ability.rb'
load '../Containers/move.rb'

class MovesParser
	attr_accessor :baseHTML_forDoc, :moveName_forDoc, :allMovesDoc, :movesNameMap

	def initialize(args = {}) 
		@baseHTML_forDoc = "http://pokemondb.net"
		@moveName_forDoc = "http://pokemondb.net/move/all"
		@allMovesDoc = Nokogiri::HTML(open(@moveName_forDoc))
		@movesNameMap = {}
	end

	def parsePokemonDB() 
		movesList = @allMovesDoc.css("table#moves > tbody > tr > td > a.ent-name")
		#puts
		 movesList.length
		# #puts
		 movesList[0]

		# For loop that iterates through all moves.
			# For every iteration we go to the specific move's
			# page and create a class for the info.
		for allMovesCount in 0...movesList.length
			currentMoveArgs = {}
			htmlMoveName = movesList[allMovesCount]['href']
			currentMoveHtml = @baseHTML_forDoc+htmlMoveName
			
			currentMoveDoc = Nokogiri::HTML(open(currentMoveHtml))

			##########################################################################
			# Collecting all of the data on pokemon moves: 						 	 #
			# :name, :type, :pp, :power, :accuracy, :category, :damage, :description #
			##########################################################################
			# For: Name, 
			currentMoveName = currentMoveDoc.css("head > title").text
			#puts
			 currentMoveName = currentMoveName[0,currentMoveName.index('|')].strip()
			currentMoveArgs[:name] = currentMoveName

			# For Description:
			currentMoveDescription = currentMoveDoc.css('article > div.colset > div.col')
			#puts
			 currentMoveDescription = currentMoveDescription[1].css('p')[0].text.strip()
			##########################################################################
			# For: Type, Category, Power, Accuracy, PP 							     #
			##########################################################################
			restOfMoveInfoDoc = currentMoveDoc.css('article > div.colset > div.col > table > tbody > tr')
			# For Type: 
			typeStr = restOfMoveInfoDoc[0].css('a').text.strip()
			if (typeStr == "-")
				#puts
				 currentMoveArgs[:type] = "0"
			else
				#puts
				 currentMoveArgs[:type] = typeStr
			end

			# For Category:
			categoryStr = restOfMoveInfoDoc[1].css('i').text.strip()
			if (categoryStr == "-")
				#puts
				 currentMoveArgs[:category] = "0"
			else
				#puts
				 currentMoveArgs[:category] = categoryStr
			end

			# For Power
			powerStr = restOfMoveInfoDoc[2].css('td').text.strip()
			if (powerStr == "-")
				#puts
				 currentMoveArgs[:power] = "0"
			else 
				#puts
				 currentMoveArgs[:power] = powerStr
			end

			# For Accuracy:
			accuracyStr = restOfMoveInfoDoc[3].css('td').text.strip()
			if (accuracyStr == "-")
				#puts
				 currentMoveArgs[:accuracy] = "0"
			elsif (accuracyStr == "∞")
				#puts
				 currentMoveArgs[:accuracy] = "101"
			else
				#puts
				 currentMoveArgs[:accuracy] = accuracyStr
			end
			
			# For PP:
			ppString = restOfMoveInfoDoc[4].css('td').text.strip()
			if ((ppString.strip() == "") || (ppString == "-"))
				#puts
				 currentMoveArgs[:pp] = "0"
			else 
				ppString = ppString[0,ppString.index(' ')].strip()
			 	#puts
			 	 currentMoveArgs[:pp] = ppString
			end


			##########################################################################
			# Done Parsing, create object										     #
			##########################################################################
			currentMoveObject = Move.new(currentMoveArgs)
			@movesNameMap[htmlMoveName] = currentMoveObject
			puts htmlMoveName
			puts currentMoveObject.to_s

			sleep 0.45
		end
	end

	def to_json(fileName)
		if(@movesNameMap == nil) 
			return;
		end
		writeFile = File.open(fileName, "w")
		writeFile.puts("{\n")
		writeFile.puts("\t\"Moves\":[\n")

		puts movesNameMap["/move/zen-headbutt"].to_s
		movesNameMapKeys = @movesNameMap.keys
		count = 0
		max = movesNameMapKeys.length
		for currentMoveKey in movesNameMapKeys
			if(count != max-1)
				moveNameStr = @movesNameMap[currentMoveKey].to_s
				moveNameStr += ","
				writeFile.puts( moveNameStr)
			else
				writeFile.puts(@movesNameMap[currentMoveKey].to_s)
			end
			count+= 1
		end

		writeFile.puts("\t]\n")
		writeFile.puts("}")
		
		writeFile.close()
	end

end
args = {}

test = MovesParser.new(args)
test.parsePokemonDB()

test.to_json("AllMoves.json")
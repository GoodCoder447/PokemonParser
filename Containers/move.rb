class Move
	attr_accessor :name, :type, :pp, :power, :accuracy, 
			      :category, :damage, :description

	def initialize(args={})
		args = defaults.merge(args)
		@name = args[:name]
		@type = args[:type]
		@pp = args[:pp]
		@power = args[:power]
		@accuracy = args[:accuracy]
		@category = args[:accuracy]
		@damage = args[:damage]
		@description = args[:description]
	end

	def defaults
		{
			:name => "",
		 	:type => "",
		 	:pp => 0,
		 	:power => 0,
		 	:accuracy => 0,
		 	:category => "",
		 	:damage => 0,
		 	:description => 0
		}
	end

	def to_s
		return ("\t{\n" +
			"\t\"Name\": \"#{name}\",\n" + 
			    "\t\"Type\": \"#{type}\",\n" +
			    "\t\"PP\": \"#{pp}\",\n" +
			    "\t\"Power\": \"#{power}\",\n" +
			    "\t\"Accuracy\": \"#{accuracy}\",\n" +
			    "\t\"Category\": \"#{accuracy}\",\n" +
			    "\t\"Damage\": \"#{damage}\",\n" +
			    "\t\"Description\": \"#{description}\"\n"+
			    "\t}")
	end
end

# args = {}
# move = Move.new(args)
# puts move

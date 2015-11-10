class Pokemon
	attr_accessor :national_dex_number, :name, :species, :types,
				  :abilities, :gender_threshold, :catch_rate,
				  :egg_groups, :hatch_counter, :height, :weight,
				  :base_exp_yield, :base_friendship, :exp_group,
				  :ev_yield, :body_style, :color, :base_stats,
				  :pokedexEntry_x, :pokedexEntry_y, :pokedexEntry_or,
				  :pokedexEntry_as, :learnSet_level_xy, :learnSet_level_oras,
				  :learnSet_machine, :learnSet_eggMove,
				  :learnSet_tutor, :learnSet_special,:learnSet_evolve,
				  :learnSet_transfer

	def initialize(args = {})
		args = defaults.merge(args)
		@national_dex_number = args[:national_dex_number]
		@name = args[:name]
		@species = args[:species]
		@types = args[:types]
		@abilities = args[:abilities]
		@gender_threshold = args[:gender_threshold]
		@catch_rate = args[:catch_rate]
		@egg_groups = args[:egg_groups]
		@hatch_counter = args[:hatch_counter]
		@height = args[:height]
		@weight = args[:weight]
		@base_exp_yield = args[:base_exp_yield]
		@base_friendship = args[:base_friendship]
		@exp_group = args[:exp_group]
		@ev_yield = args[:ev_yield]
		@body_style = args[:body_style]
		@color = args[:color]
		@base_stats = args[:base_stats]
		@pokedexEntry_x = args[:pokedexEntry_x]
		@pokedexEntry_y = args[:pokedexEntry_y]
		@pokedexEntry_as = args[:pokedexEntry_as]
		@pokedexEntry_or = args[:pokedexEntry_or]
		@learnSet_level_xy = args[:learnSet_level_xy]
		@learnSet_level_oras = args[:learnSet_level_oras]
		@learnSet_machine = args[:learnSet_machine]
		@learnSet_eggMove = args[:learnSet_eggMove]
		@learnSet_tutor = args[:learnSet_tutor]
		@learnSet_special = args[:learnSet_special]
		@learnSet_evolve = args[:learnSet_evolve]
		@learnSet_transfer = args[:learnSet_transfer]
	end

	def defaults
		{
			:national_dex_number => 0,
			:name => "None",
			:species => "None",
			:types => [0,0],
			:abilities => [0,0,0],
			:gender_threshold => 0,
			:catch_rate => 0,
			:egg_groups => 0,
			:hatch_counter => 0,
			:height => 0.0,
			:weight => 0.0,
			:base_exp_yield => 0,
			:exp_group => 0,
			:ev_yield => [0,0,0,0,0,0],
			:body_style => 0,
			:color => 0,
			:base_stats => [0,0,0,0,0,0],
			:pokedexEntry_x => "None",
			:pokedexEntry_y => "None",
			:pokedexEntry_as => "None",
			:pokedexEntry_or => "None",
			:learnSet_level_xy => [],
			:learnSet_level_oras => [],
			:learnSet_machine => [],
			:learnSet_eggMove => [],
			:learnSet_tutor => [],
			:learnSet_special => [],
			:learnSet_evolve => [],
			:learnSet_transfer => []
		}
	end

	def to_s
		return(
			"\t\"Dex \#\": #{national_dex_number}\n"+
			"\t\"Name\": #{name}\n"+
			"\t\"Species\": #{species}\n"+
			"\t\"Types\": #{types}\n"+
			"\t\"Abilities\": #{abilities}\n"+
			"\t\"Gender Threshold\": #{gender_threshold}\n"+
			"\t\"Catch Rate\": #{catch_rate}\n"+
			"\t\"Egg Groups\": #{egg_groups}\n"+
			"\t\"Hatch Counter\": #{hatch_counter}\n"+
			"\t\"Height\": #{height}\n"+
			"\t\"Weight\": #{weight}\n"+
			"\t\"Base Exp Yield\": #{base_exp_yield}\n"+
			"\t\"Base Friendship:\" #{base_friendship}\n"+
			"\t\"Exp Group\": #{exp_group}\n"+
			"\t\"EV Yield\": #{ev_yield}\n"+
			"\t\"Body Style\": #{body_style}\n"+
			"\t\"Color\": #{color}\n"+
			"\t\"Base Stats\": #{base_stats}\n"+
			"\t\"Pokedex Entry (X)\": #{pokedexEntry_x}\n"+
			"\t\"Pokedex Entry (Y)\": #{pokedexEntry_y}\n"+
			"\t\"Pokedex Entry (OR)\": #{pokedexEntry_or}\n"+
			"\t\"Pokedex Entry (AS)\": #{pokedexEntry_as}\n"+
			"\t\"Learnset (XY)\": #{learnSet_level_xy}\n"+
			"\t\"Learnset (ORAS)\": #{learnSet_level_oras}\n"+
			"\t\"Learnset (TM/HM)\": #{learnSet_machine}\n"+
			"\t\"Learnset (Tutor)\": #{learnSet_tutor}\n"+
			"\t\"Learnset (Special)\": #{learnSet_special}\n"+
			"\t\"Learnset (Pre-evo)\": #{learnSet_evolve}\n"+
			"\t\"Learnset (Transfer)\": #{learnSet_transfer}\n"
	 	)
	end
end
# args = {}
# p = Pokemon.new(args)
# puts p

















class Ability
	attr_accessor :name, :description

	def initialize(args={})
		@name = args[:name] || ""
		@description = args[:description] || ""
	end

	def to_s
		return ("\t{\n" +
                                "\t\t\"Name\": \"#{name}\",\n" +
		          "\t\t\"Description\": \"#{description}\"\n" +
                                "\t}")
	end
end
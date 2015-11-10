class EggGroups
    attr_accessor :Amorphous, :Bug, :Dragon, :Fairy, :Field, :Flying, :Grass, :Human_Like, 
                         :Mineral, :Monster, :Water1, :Water2, :Water3, :Ditto, :Undiscovered
    def initialize ()
        @Amorphous =  "Amorphous",
        @Bug = "Bug",
        @Dragon =  "Dragon",
        @Fairy =  "Fairy",
        @Field =  "Field",
        @Flying =  "Flying",
        @Grass =  "Grass",
        @Human_Like =  "Human-Like",
        @Mineral =  "Mineral",
        @Monster =  "Monster",
        @Water1 =  "Water1",
        @Water2 = "Water2",
        @Water3 =  "Water3",
        @Ditto =  "Ditto",
        @Undiscovered  =  "Undiscovered"
    end

    def switch(ability)
        if (ability == "Amorphous") 
            return 0
        end
        if (ability == "Bug") 
            return 1
        end
        if (ability == "Dragon") 
            return 2
        end
        if (ability == "Fairy") 
            return 3
        end
        if (ability == "Flying") 
            return 4
        end
        if (ability == "Grass") 
            return 5
        end
        if (ability == "Human-Like") 
            return 6
        end
        if (ability == "Monster") 
            return 7
        end
        if (ability == "Water1") 
            return 8
        end
        if (ability == "Water2") 
            return 9
        end
        if (ability == "Water3") 
            return 10
        end
        if (ability == "Ditto") 
            return 11
        end
        if (ability == "Undiscovered") 
            return 12
        end
    end
end
    # Amorphous   
    # Bug 
    # Dragon 
    # Fairy   
    # Field   
    # Flying  
    # Grass 
    # Human-Like
    # Mineral 
    # Monster 
    # Water 1 
    # Water 2 
    # Water 3
    # Ditto   
    # Undiscovered 


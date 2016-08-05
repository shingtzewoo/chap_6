class Dungeon
  attr_accessor :player


  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def start(location)
    player_in_dungeon = true
    @player.location = location
    show_current_description
    while player_in_dungeon
      puts "\nWhat do you want to do? You can: go, show (current location), leave (exit the dungeon)."
      answer = gets.chomp.downcase
      case answer
      when "go"
        puts "\nWhich direction would you like to go?"
        direction = gets.chomp.downcase
        self.go(direction.to_sym)
      when "show"
        self.show_current_description
      when "leave"
        player_in_dungeon = false
        exit
      else
        puts "Invalid choice!"
      end
    end
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "\nYou go " + direction.to_s
    @player.location = find_room_in_direction(direction)
    show_current_description
  end

  class Player
    attr_accessor :name, :location
    def initialize(name)
      @name = name
    end
  end

  class Room
    attr_accessor :reference, :name, :description, :connections
    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end
    def full_description
      @name + "\n\nYou are in " + @description
    end
  end

  private :find_room_in_dungeon, :find_room_in_direction

end

# Create the main dungeon object
my_dungeon = Dungeon.new("Fred Bloggs")

# Add rooms to the dungeon
my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave })
my_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:east => :largecave })

# Start the dungeon by placing the player in the large cave
my_dungeon.start(:largecave)
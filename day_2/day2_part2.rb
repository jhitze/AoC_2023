file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

class Game 
    attr_accessor :line, :id, :sets
    def initialize(line)
        @line = line
        @id = find_game_number_from line
        @sets = find_sets_from line
    end

    def find_game_number_from(line)
        first_part = line.split(':').first
        game_number = first_part.split(' ').last
        game_number.to_i
    end

    def find_sets_from(line)
        second_part = line.split(":").last
        sets_strings = second_part.split(";")
        sets = sets_strings.map{|set_string| GameSet.new set_string}
    end

    def possible?
        @sets.all? {|game_set| game_set.possible?}
    end

    def minimum_count(color)
        color_cubes = []
        @sets.each do |game_set|
            cubes = game_set.cubes.select{|cube| cube.color == color}.first
            color_cubes.append(cubes) unless cubes.nil?
        end
        max = color_cubes.max_by(&:count)
        return max.count
    end

    def power
        colors = ["red", "blue", "green"]

        minimum_set = colors.map{ |color| minimum_count color}
                            .reduce { |sum, cube_count| sum * cube_count}
    end
end

class GameSet
    attr_accessor :cubes

    def initialize(sets_part_of_line)
        @sets_part_of_line = sets_part_of_line
        @cubes = find_cubes_from @sets_part_of_line
    end

    def find_cubes_from(sets_part_of_line)
        cubes_strings = sets_part_of_line.split(',')
        cubes_strings.map {|cube_string| GameCube.new cube_string}
    end

    def possible?
        @cubes.each do |game_cube|
            if game_cube.color == "red" and game_cube.count > 12
                return false
            end
            if game_cube.color == "blue" and game_cube.count > 14
                return false
            end
            if game_cube.color == "green" and game_cube.count > 13
                return false
            end
        end

        return true
    end
end

class GameCube
    attr_accessor :count, :color
    def initialize(cube_part_of_line)
        @cube_part_of_line = cube_part_of_line
        string_split = @cube_part_of_line.split(' ')
        @count = string_split.first.to_i
        @color = string_split.last
    end
end

games = file_data.map{|line| Game.new line}

sum_of_ids_for_possible_games = 0
sum_of_power = 0
games.each do |game|
    if game.possible?
        sum_of_ids_for_possible_games += game.id
    end
    sum_of_power += game.power
end

puts "Sum of IDs for possible games: #{sum_of_ids_for_possible_games}"
puts "Sum of Power for all games: #{sum_of_power}"
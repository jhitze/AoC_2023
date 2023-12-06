# Monkey Patching ftw
class Array
    def second
        self.length <= 1 ? nil : self[1]
    end

    def third
        self.length <=2 ? nil : self[2]
    end
end

class Almanac
    def initialize(lines)
        @lines = lines
        @sections = split_sections_from_lines(@lines)
        @seeds = find_seeds_from @sections[0]
        @seed_to_soil_map = ThingToThingMap.new @sections[1]
        @soil_to_fertilizer_map = ThingToThingMap.new @sections[2]
        @fertilizer_to_water_map = ThingToThingMap.new @sections[3]
        @water_to_light_map = ThingToThingMap.new @sections[4]
        @light_to_temperature_map = ThingToThingMap.new @sections[5]
        @temperature_to_humidity_map = ThingToThingMap.new @sections[6]
        @humidity_to_location_map = ThingToThingMap.new @sections[7]

        @seed_locations = {}
        find_locations_for_seeds @seeds

        puts "Seed locations ->#{@seed_locations.inspect}"
        puts "Lowest location is #{find_lowest_location_for_seeds @seed_locations}"
    end

    def split_sections_from_lines(lines)
        sections = lines.slice_after(/^$/)
        sections.to_a.map {|section| section.reject{|line| line.empty?}}
    end

    def find_seeds_from(section_lines)
        line = section_lines.first
        seed_string = line.split(':').last
        seeds = seed_string.split(' ').map(&:to_i)
        puts "Seeds -> #{seeds.inspect}"
        
        seeds
    end

    def find_locations_for_seeds(seeds)
        seeds.map do |seed|
            location = find_location_for_seed seed
            @seed_locations[seed] = location
        end
    end

    def find_location_for_seed(seed)
        puts "=" * 40
        puts "Starting location search for seed #{seed}"
        soil_destination = @seed_to_soil_map.find_destination_value_for_source seed
        fertilizer_destination = @soil_to_fertilizer_map.find_destination_value_for_source soil_destination
        water_destination = @fertilizer_to_water_map.find_destination_value_for_source fertilizer_destination
        light_destination = @water_to_light_map.find_destination_value_for_source water_destination
        temperature_destination = @light_to_temperature_map.find_destination_value_for_source light_destination
        humidity_destination = @temperature_to_humidity_map.find_destination_value_for_source temperature_destination
        location = @humidity_to_location_map.find_destination_value_for_source humidity_destination
        puts "    ---> Seed #{seed} goes in Location #{location}"
        return location
    end

    def find_lowest_location_for_seeds(seed_locations)
        seed_locations.values.min
    end
end

class ThingToThingMap
    attr_accessor :name
    def initialize(section_lines)
        @name = find_name_from section_lines.first
        @maps = section_lines.drop(1).map {|section_line| RangeMap.new section_line}
        puts @name.inspect
        puts @maps.inspect
    end

    def find_name_from(section_line)
        section_line.split(" ").first
    end

    def find_destination_value_for_source(source_value)
        puts "Looking for #{source_value} in #{@name}"
        destination_value = nil
        @maps.each do |map|
            # puts "Looking at Map #{map.inspect}"
            destination_found = map.find_destination_for_source source_value
            next if destination_found.nil?
            destination_value = destination_found
        end
        destination_value = source_value if destination_value.nil?
        return destination_value
    end
end

class RangeMap
    def initialize(range_line)
        numbers = range_line.split(" ")
        @destination = numbers.first.to_i
        @source = numbers.second.to_i
        @range = numbers.third.to_i
    end

    def find_destination_for_source(source_value)
        puts "    Looking in range #{(@source..@source+@range-1).inspect} for #{source_value}"
        if (@source..@source+@range-1).include? source_value
            difference = source_value - @source 
            puts "    Difference #{source_value} - #{@source} = #{difference}"
            destination_lookup = @destination + difference
            puts "    Destination #{destination_lookup}"
        end
        return destination_lookup
    end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
almanac = Almanac.new file_data

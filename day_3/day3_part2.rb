# doesn't work

class Schematic
    attr_accessor :part_numbers, :rejected_check_strings, :accepted_check_strings
    def initialize(lines)
        @lines = lines
        @part_numbers = []
        @accepted_check_strings = []
        @rejected_check_strings = []
        @gear_ratios = []
        find_gears
    end

    def find_gears
        @lines.each_index do |line_number|
            puts "#" * 20
            current_line = @lines[line_number]
            asterisks = current_line.scan(/\*/)
            puts asterisks.inspect
            next if asterisks.count == 0

            asterisks.each_index do |index_number|
                check_around line_number, index_number, asterisks[index_number]
                puts "%" * 20
            end
            puts "-" * 20
        end
    end

    def check_around(line_number,index_number, asterisks_index)
        puts "checking around number #{asterisks_index} on line #{line_number}"
        check_above line_number, index_number, asterisks_index or 
        check_current line_number, index_number, asterisks_index or
        check_below line_number, index_number, asterisks_index
    end

    def check_above(line_number, index_number, number)
        return if line_number == 0 

        above_line_number = line_number - 1
        puts "checking above"
        check_line line_number, above_line_number, index_number, number
    end

    def check_below(line_number, index_number, number)        
        below_line_number = line_number + 1
        return if below_line_number == @lines.count
        puts "checking below"
        check_line line_number, below_line_number, index_number, number
    end

    def check_current(line_number, index_number, number)
        puts "checking current"
        check_line line_number, line_number, index_number, number
    end

    def check_line(current_line_number, line_number_to_check, index_number, number)
        current_line = @lines[current_line_number]
        line_to_check = @lines[line_number_to_check]

        offsets = current_line.enum_for(:scan, /(?<![\w\d])\d+(?![\w\d])/).map do
            Regexp.last_match.offset(0).first
        end

        puts "Found offsets: #{offsets}"
        number_index = offsets[index_number]
        puts "using index #{index_number}"
        puts "number_index #{number_index}"
        index_to_check = number_index == 0 ? number_index : number_index -1;
        number_length_to_check = number_index == 0? number.to_s.length + 1 : number.to_s.length + 2
        puts "number index [#{number_index}] starting at #{index_to_check} for #{number_length_to_check}"

        string_to_check = line_to_check.slice index_to_check, number_length_to_check
        if check_for_special_characters string_to_check
            puts "           Valid part number found - #{number}"
            @part_numbers.append(number.to_i)
            @accepted_check_strings.append(string_to_check)
            return true
        end
        puts "           Rejected"
        @rejected_check_strings.append(string_to_check)
        return false
    end

    def check_for_gear_indicator(string_to_check) 
        puts "looking at [#{string_to_check}]"

        return string_to_check.match? /\*/
    end

    def gear_ratio_sum
        return @gear_ratios.sum
    end
end

# file = File.open("input.txt")
# file_data = file.readlines.map(&:chomp)
# schematic = Schematic.new file_data
# puts schematic.rejected_check_strings.inspect
# puts schematic.accepted_check_strings.inspect
# puts "part numbers: #{schematic.part_numbers.inspect}"



test1 = Schematic.new [
"467..114..",
"...*......",
"..35..633.",
"......#...",
"617*......",
".....+.58.",
"..592.....",
"......755.",
"...$.*....",
".664.598.."
]

puts "%%%%%%% Tests %%%%%%"
puts test1.gear_ratio_sum
puts test1.gear_ratio_sum == 467835


puts "%%%%%%%       %%%%%%"

# puts "part number sum: #{schematic.part_number_sum}"
class Schematic
    attr_accessor :part_numbers, :rejected_check_strings, :accepted_check_strings
    def initialize(lines)
        @lines = lines
        @part_numbers = []
        @accepted_check_strings = []
        @rejected_check_strings = []
        find_part_numbers
    end

    def find_part_numbers
        @lines.each_index do |line_number|
            current_line = @lines[line_number]
            numbers = current_line.scan(/(?<![\w\d])\d+(?![\w\d])/)
            puts numbers.inspect
            numbers.each_index do |index_number|
                check_around line_number, index_number, numbers[index_number]
                puts "*" * 20
            end
            puts "-" * 20
        end
    end

    def check_around(line_number,index_number, number)
        puts "checking around number #{number} on line #{line_number}"
        check_above line_number, index_number, number or 
        check_current line_number, index_number, number or
        check_below line_number, index_number, number
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
        # (?<![\w\d])467(?![\w\d])
        #/(?:[^0-9.])*#{number}+/
        # /\d+/
        # /(?<![\w\d])#{number}(?![\w\d])/
        offsets = current_line.enum_for(:scan, /(?<![\w\d])\d+(?![\w\d])/).map do
            Regexp.last_match.offset(0).first
        end

        puts "Found offsets: #{offsets}"
        # number_index = current_line.match?(/(?<![\w\d])#{number}(?![\w\d])/).to_a[index_number].to_i
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

    def check_for_special_characters(string_to_check) 
        puts "looking at [#{string_to_check}]"

        return string_to_check.match? /[^0-9.]/
    end

    def part_number_sum
        return @part_numbers.sum
    end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
schematic = Schematic.new file_data
puts schematic.rejected_check_strings.inspect
puts schematic.accepted_check_strings.inspect
puts "part numbers: #{schematic.part_numbers.inspect}"


test1 = Schematic.new ["........",
".24..4..",
"......*."]
test2 = Schematic.new ["........",
                       ".24$-4..",
                       "......*."]
test3 = Schematic.new ["11....11",
"..$..$..",
"11....11"]
test4 = Schematic.new ["$......$",
".1....1.",
".1....1.",
"$......$"]
test5 = Schematic.new ["$......$",
".11..11.",
".11..11.",
"$......$",]
test6 = Schematic.new ["$11",
"...",
"11$",
"..."]
test7 = Schematic.new ["$..",
".11",
".11",
"$..",
"..$",
"11.",
"11.",
"..$"]
test8 = Schematic.new ["11.$."]
test9 = Schematic.new [
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
test10 = Schematic.new [
".......5......",
"..7*..*.....4*",
"...*13*......9",
".......15.....",
"..............",
"..............",
"..............",
"..............",
"..............",
"..............",
"21............",
"...*9........."
]
test11 = Schematic.new [
"9.",
".$.11"
]
test12 = Schematic.new [
    "12+.",
    "...."
]
test13 = Schematic.new [
"97..",
"...*",
"100."
]
test14 = Schematic.new [
"$......$",
".11..11.",
".11.11..",
"$......$"
]

test15 = Schematic.new [
"$......$11",
".11..11...",
".11.11..11",
"$......$.."
]
test16 = Schematic.new [
"....573.613........................691...",
".......*.............*.....814..........."
]
puts "%%%%%%% Tests %%%%%%"
puts test1.part_number_sum == 4
puts test2.part_number_sum == 28
puts test3.part_number_sum == 44
puts test4.part_number_sum == 4
puts test5.part_number_sum == 44
puts test6.part_number_sum == 22
puts test7.part_number_sum == 44
puts test8.part_number_sum == 0
puts test9.part_number_sum == 4361
# puts test10.part_numbers.inspect
puts test10.part_number_sum == 62
puts test11.part_number_sum == 9
puts test12.part_number_sum == 12
puts test13.part_number_sum == 100
puts test14.part_number_sum == 33
puts test15.part_number_sum == 55
puts test16.part_number_sum

puts "%%%%%%%       %%%%%%"

puts "part number sum: #{schematic.part_number_sum}"
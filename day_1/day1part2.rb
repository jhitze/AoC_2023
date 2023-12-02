
file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

line_numbers = []

def replace_words_with_numbers_in(line)
    word_numbers = {
        "one" => 1,
        "two" => 2,
        "three" => 3,
        "four" => 4,
        "five" => 5,
        "six" => 6,
        "seven" => 7,
        "eight" => 8,
        "nine" => 9
    }

    line_to_check = line
    new_line_to_use = ""
    
    (0...line_to_check.length).each do | check_width |
        word_numbers.each do |word, number|
            if line[check_width].match(/[0-9]/)
                new_line_to_use += line[check_width]
                break
            end
            if line[0+check_width..line_to_check.length].start_with? word
                new_line_to_use += number.to_s
                puts "subbing #{word}"
            end
        end
    end

    puts "New number: #{new_line_to_use}" 

    return new_line_to_use
end

file_data.each do |line|
    puts "starting with #{line}"
    wordless_number_line = replace_words_with_numbers_in line
    numbers_only_line = wordless_number_line.delete("^0-9")
    first_number = numbers_only_line.chars.first
    line_number = first_number

    last_number = numbers_only_line.chars.last
    line_number += last_number
    
    line_numbers.append(line_number.to_i)
    puts "Final Number #{line_number}"
    puts "--------"
end

total = line_numbers.sum

puts "Total: #{total}"

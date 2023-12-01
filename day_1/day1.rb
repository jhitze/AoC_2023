
file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
line_numbers = []

file_data.each do |line|
    numbers_only_line = line.delete("^0-9")
    first_number = numbers_only_line.chars.first
    line_number = first_number

    last_number = numbers_only_line.chars.last
    line_number += last_number
    
    line_numbers.append(line_number.to_i)
    puts line_number
end

total = line_numbers.sum

puts total

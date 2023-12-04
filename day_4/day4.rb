class GiftScratchCards
    # attr_accessor :part_numbers, :rejected_check_strings, :accepted_check_strings
    def initialize(lines)
        @lines = lines
        @cards = @lines.map{|card_line| check_card card_line}
    end

    def check_card(card_line)
        ScratchCard.new card_line
    end

    def points
        @cards.sum { |card| card.points }
    end
end

class ScratchCard
    def initialize(card_line)
        @card_line = card_line
        @card_number = find_game_number_from @card_line
        @winning_numbers = []
        find_card_numbers_from @card_line
        find_winning_numbers
    end

    def find_game_number_from(card_line)
        first_part = card_line.split(':').first
        game_number = first_part.split(' ').last
        game_number.to_i
    end

    def find_card_numbers_from(card_line)
        card_numbers = card_line.split(":").last
        @winable_numbers = find_winable_numbers_from card_numbers
        @played_numbers = find_played_numbers_from card_numbers
    end

    def find_winable_numbers_from(card_numbers)
        first_part = card_numbers.split("|").first
        first_set_of_numbers = first_part.split(" ").map{|number| number.to_i}
        # puts first_set_of_numbers.inspect
    end

    def find_played_numbers_from(card_numbers)
        second_part = card_numbers.split("|").last
        first_set_of_numbers = second_part.split(" ").map{|number| number.to_i}
    end

    def find_winning_numbers
        @played_numbers.each do |played_number|
            if @winable_numbers.include? played_number
                @winning_numbers.append(played_number)
            end
        end
        # puts "#{@winning_numbers.inspect}"
    end

    def points
        points = @winning_numbers.count == 0? 0 : 2 ** (@winning_numbers.count - 1);
        puts "card ##{@card_number} | winning numbers -> #{@winning_numbers.count}, points -> #{points.inspect}"
        return 0 if @winning_numbers.count == 0
        return points
    end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
gift_sratch_cards = GiftScratchCards.new file_data
puts gift_sratch_cards.points
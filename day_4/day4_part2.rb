class GiftScratchCards
    def initialize(lines)
        @lines = lines
        @cards = @lines.map{|card_line| check_card card_line}
        process_scoring
    end

    def check_card(card_line)
        ScratchCard.new card_line
    end

    def process_scoring()
        @cards.each_index do |card_index| 
            number_of_winnning_numbers = @cards[card_index].winning_numbers.count
            @cards[card_index].copies.times do
                (1..number_of_winnning_numbers).each do |card_number_increment|
                    @cards[card_index + card_number_increment].add_copy
                end
            end
        end
    end

    def total_scratchcards()
        @cards.sum{ |card| card.copies}
    end
end

class ScratchCard
    attr_accessor :copies, :winning_numbers
    def initialize(card_line)
        @card_line = card_line
        @card_number = find_game_number_from @card_line
        @winning_numbers = []
        @copies = 1
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
    end

    def add_copy
        @copies += 1
    end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
gift_sratch_cards = GiftScratchCards.new file_data
puts gift_sratch_cards.total_scratchcards
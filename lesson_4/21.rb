
require 'pry'

CARD_VALUES = [
  ["2", 2], ["3", 3], ["4", 4], ["5", 5], ["6", 6], ["7", 7],
  ["8", 8], ["9", 9], ["10", 10], ["J", 10], ["Q", 10],
  ["K", 10], ["A", 11]
].freeze

CARD_SUITS = ["S", "D", "C", "H"].freeze
DEALER_FLOOR = 17
MAX_HAND_VALUE = 21

def initialize_deck
  deck = []
  CARD_VALUES.each do |card|
    4.times do |counter|
      card_triple = [card[0], card[1], CARD_SUITS[counter - 1]]
      deck.push(card_triple)
    end
  end
  deck
end

def deal_hand(deck, hand)
  2.times do
    deal_a_card(deck, hand)
  end
end

def deal_a_card(deck, hand)
  single_card = deck.sample
  deck.delete_at(deck.index(single_card))
  hand.push(single_card)
end

def display_hand(hand, mask)
  hand_output = ""
  hand.each do |card|
    hand_output.concat(card[0]).concat(card[2])
    hand_output.concat(" ")
  end

  if mask == 1
    hand_output[0] = "X"
    hand_output[1] = "X"
    hand_output[2] = " "
  end
  hand_output
end

def value_of_hand(hand)
  hand_total = 0
  hand.each do |card|
    hand_total += card[1]
  end

  revised_hand_total = handle_aces(count_aces(hand), hand_total)
  revised_hand_total
end

def handle_aces(ace_count, hand_total)
  return hand_total if ace_count == 0
  hand_total -= (ace_count - 1) * 10 if ace_count > 1
  hand_total -= 10 if hand_total > MAX_HAND_VALUE
  hand_total
end

def count_aces(hand)
  ace_count = 0
  hand.count { |card| ace_count += 1 if card[0] == "A" }
  ace_count
end

def display_hand_and_total(player_or_dealer, hand, hide_dealer_info)
  puts "#{player_or_dealer} hand: #{display_hand(hand, hide_dealer_info)}\
    Total: #{hide_dealer_info == 0 ? value_of_hand(hand) : '??'}"
end

def bust?(hand)
  value_of_hand(hand) > MAX_HAND_VALUE
end

def dealer_move(dealer_hand)
  if value_of_hand(dealer_hand) < DEALER_FLOOR
    return "hit"
  elsif value_of_hand(dealer_hand) <= MAX_HAND_VALUE
    return "stay"
  else
    "bust"
  end
end

def who_wins(player_hand, dealer_hand)
  if bust?(player_hand)
    return { winner: "dealer", msg: "Sorry, you busted!" }
  elsif bust?(dealer_hand)
    return { winner: "player", msg: "Congrats! Dealer busted!" }
  elsif value_of_hand(player_hand) > value_of_hand(dealer_hand)
    return { winner: "player", msg: "Congrats! You had the better hand!" }
  elsif value_of_hand(player_hand) < value_of_hand(dealer_hand)
    return { winner: "dealer", msg: "Too bad! Dealer had the better hand!" }
  else
    return { winner: "tie", msg: "It's a tie, how exciting!" }
  end
end

def manage_end_game(player_hand, dealer_hand, hand_tally)
  result = who_wins(player_hand, dealer_hand)
  puts result[:msg]
  if result[:winner] == "player"
    hand_tally[:wins] += 1
  elsif result[:winner] == "dealer"
    hand_tally[:losses] += 1
  else
    hand_tally[:ties] += 1
  end
  puts "Hands Won: #{hand_tally[:wins]}\
    Hands Lost: #{hand_tally[:losses]}\
    Hands Tied: #{hand_tally[:ties]}"
end

def display_table_info(player_hand, dealer_hand, dealer_mask)
  system("clear")
  display_hand_and_total("Player", player_hand, 0)
  display_hand_and_total("Dealer", dealer_hand, dealer_mask)
end

hand_tally = { wins: 0, losses: 0, ties: 0 }

loop do
  deck = initialize_deck
  player_hand = []
  dealer_hand = []
  deal_hand(deck, player_hand)
  deal_hand(deck, dealer_hand)
  display_table_info(player_hand, dealer_hand, 1)

  loop do
    hit_or_stand = ""
    loop do
      puts "Do you want to hit or stay (h or s):"
      hit_or_stand = gets.chomp.downcase
      break if ["h", "hit", "s", "stand"].include?(hit_or_stand)
      puts "Please enter either 'h' or 's'!"
    end

    if hit_or_stand.start_with?("h")
      deal_a_card(deck, player_hand)
      display_table_info(player_hand, dealer_hand, 1)
      break if bust?(player_hand)
    else
      break
    end
  end

  loop do # dealer's turn
    break if bust?(player_hand)
    display_table_info(player_hand, dealer_hand, 0)

    case dealer_move(dealer_hand)
    when "hit"
      puts "Dealer hit!"
      deal_a_card(deck, dealer_hand)
    when "stay"
      puts "Dealer stays!"
      break
    when "bust"
      break
    end
  end

  puts ""
  manage_end_game(player_hand, dealer_hand, hand_tally)

  puts ""
  puts "Do you want to play again (y/n)?"
  play_again = gets.chomp.downcase
  break unless play_again.start_with?("y")
end

puts "Thanks for playing!"

NUM_ROUNDS = 5
DISPLAY_CHOICES = %w(rock paper scissors lizard spock).freeze
VALID_CHOICES = {
  "rock" => %w(r rock),
  "paper" => %w(p paper),
  "scissors" => %w(s scissors),
  "lizard" => %w(l lizard),
  "spock" => %w(s spock)
}.freeze

BEATS = {
  'rock' => %w(scissors lizard),
  'paper' => %w(rock spock),
  'scissors' => %w(paper lizard),
  'lizard' => %w(paper spock),
  'spock' => %w(rock scissors)
}.freeze

def clear_screen
  system('clear') || system('cls')
end

def win?(first, second)
  BEATS[first].include?(second)
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("you won!")
  elsif win?(computer, player)
    prompt("computer won!")
  else
    prompt("its a tie!")
  end
end

def display_winner(human_total)
  if human_total == 5
    puts "You've won!"
  else
    puts "Sorry, the computer beat you!"
  end
end

def prompt(message)
  puts("=> #{message}")
end

computer_score = 0
human_score = 0

loop do 
  choice_found = []
  choice = ''
  
  loop do 
    prompt("Choose one: #{DISPLAY_CHOICES.join(', ')}")
    choice = gets.chomp
    clear_screen
    choice_found = []
    VALID_CHOICES.each do |standard_spelling_of_choice, variant_spelling_of_choice|
      choice_found << standard_spelling_of_choice if variant_spelling_of_choice.include?(choice.downcase)
    end 
    
    break if choice_found.length == 1

    puts "Based on your choice: #{choice}, it is unclear which of the following you meant: #{choice_found}.\n" \
          "Please retry and type in the full word of your desired choice.\n\n" if choice_found.length > 1
    puts "Your input of #{choice} was invalid.  Please try again!\n\n" if choice_found.empty?
  end 

  computer_move = DISPLAY_CHOICES.sample
  puts "You chose #{choice_found[0]} and the computer chose #{computer_move}."
  display_results(choice_found[0], computer_move)
  
  if win?(choice_found[0], computer_move)
    human_score += 1
  elsif win?(computer_move, choice_found[0])
    computer_score += 1
  end

  puts "\nYour score: #{human_score} versus computer's score: #{computer_score}.  First to #{NUM_ROUNDS} wins!\n\n"
  break if human_score == NUM_ROUNDS || computer_score == NUM_ROUNDS
end

display_winner(human_score)

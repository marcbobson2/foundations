DISPLAY_CHOICES = %w(rock paper scissors lizard spock).freeze
VALID_CHOICES = { "rock" => %w(r rock), "paper" => %w(p paper), "scissors" => %w(s scissors), "lizard" => %w(l lizard), "spock" => %w(s spock) }.freeze

choice_found = []
computer_score = 0
human_score = 0

def win?(first, second)
  (first == 'rock' && (second == 'scissors' || second == 'lizard')) ||
    (first == 'paper' && (second == 'rock' || second == 'spock')) ||
    (first == 'scissors' && (second == 'paper' || second == 'lizard')) ||
    (first == 'lizard' && (second == 'paper' || second == 'spock')) ||
    (first == 'spock' && (second == 'rock' || second == 'scissors'))
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

loop do # play_again?
  choice = ''
  loop do # gather choice, validate it, and provide error msgs for invalid selections
    prompt("Choose one: #{DISPLAY_CHOICES.join(', ')}")
    choice = gets.chomp
    # now loop through array and look for whole matches or first char matches
    choice_found = []
    VALID_CHOICES.each do |key, value|
      # now search the value array to see if choice is contained
      choice_found << key if value.include?(choice)
    end # end of compare_choice_to_valid_choices
    # now validate findings
    break if choice_found.length == 1

    puts "Based on your choice: #{choice}, it is unclear which of the following you meant: #{choice_found}.  Please retry and type in the full word of your desired choice." if choice_found.length > 1
    puts "Your input of #{choice} was invalid.  Please try again!" if choice_found.empty?
  end # loop..do

  computer_move = DISPLAY_CHOICES.sample
  puts "You chose #{choice_found[0]} and the computer chose #{computer_move}."
  display_results(choice_found[0], computer_move)
  if win?(choice_found[0], computer_move)
    human_score += 1
  elsif win?(computer_move, choice_found[0])
    computer_score += 1
  end

  puts "Your score: #{human_score} versus computer's score: #{computer_score}.  First to 5 wins!"
  break if human_score == 5 || computer_score == 5
end # play_again?

display_winner(human_score)

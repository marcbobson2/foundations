VALID_CHOICES = %w(rock paper scissors lizard spock).freeze

def win?(first, second)
  (first == 'rock' && second == 'scissors') ||
    (first == 'paper' && second == 'rock') ||
    (first == 'scissors' && second == 'paper') ||
    (first == 'rock' && second == 'lizard') ||
    (first == 'lizard' && second == 'paper') ||
    (first == 'lizard' && second == 'spock') ||
    (first == 'spock' && second == 'rock') ||
    (first == 'spock' && second == "scissors") ||
    (first == 'scissors' && second == 'lizard') ||
    (first == 'paper' && second == 'spock')
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

def prompt(message)
  puts("=> #{message}")
end

loop do
  choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = gets.chomp
    break if VALID_CHOICES.include?(choice)
    prompt("Thats not a valid choice.")
  end

  computer_choice = VALID_CHOICES.sample

  puts("You chose #{choice} and computer chose #{computer_choice}.")

  display_results(choice, computer_choice)

  prompt("Do you want to play again?")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt("thank you for playing!")

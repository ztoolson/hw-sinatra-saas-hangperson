class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :guesses, :word, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess(letter)
    fail ArgumentError if letter.nil? || !valid_guess?(letter)
    letter = letter.downcase

    return false if already_guessed?(letter)

    if word.include?(letter)
      guesses << letter
    else
      wrong_guesses << letter
    end

    true
  end

  def check_win_or_lose
    return :lose if wrong_guesses.length >= 7
    return :win unless word_with_guesses.include?('-')
    :play
  end

  def word_with_guesses
    formatted_word = ''

    word.split('').each do |letter|
      formatted_word << (guesses.include?(letter) ? letter : '-')
    end

    formatted_word
  end

  private

  def already_guessed?(letter)
    (guesses + wrong_guesses).include?(letter)
  end

  def valid_guess?(letter)
    letter =~ /^[a-z]$/i
  end

end

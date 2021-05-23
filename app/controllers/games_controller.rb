require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = []
    10.times { |_| @letters << alphabet.sample }
  end

  def score
    @grid = params[:grid].split(" ")
    @word = params[:word]
    if !english_word?(@word)
      @result = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    elsif !in_grid?(@word.upcase) || !overused_letters?(@word.upcase)
      @result = "Sorry but #{@word.upcase} cannot be built our of #{@letters}"
    else
      @result = "Congratulations! #{@word} is a valid English word!"
    end
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialised = open(url).read
    dictionary_data = JSON.parse(attempt_serialised)
    dictionary_data["found"]
  end

  def in_grid?(attempt)
  attempt.chars.each do |letter|
    return false unless @grid.include?(letter)
  end

  def overused_letters?(attempt)
    attempt_hash = Hash.new(0)
    grid_hash = Hash.new(0)
    attempt.chars.each { |letter| attempt_hash[letter] += 1 }
    @grid.each { |letter| grid_hash[letter] += 1 }
    attempt_hash.each do |key, _|
      return false unless attempt_hash[key] <= grid_hash[key]
    end
  end
end
end

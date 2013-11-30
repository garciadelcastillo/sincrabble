# Scrabble Solver app
require 'sinatra'
require 'sinatra/reloader' if development?
require './server/helpers.rb'

# HOME route
get '/' do 
	erb :index
end

# Main POST action
post '/solve' do
	@query = params[:letters]
	@letters = combine_text(params[:letters])
	@possible_words = recombine_letters(params[:letters])
	erb :scrabbled
end

# A fallback GET for the '/solve' route
get '/solve' do
	redirect to('/')
end

# Custom 404
not_found do
	status 404  
	'Page not found, sorry! XD'  
end 


helpers do

	def reverse_text(_txt)
		_txt.reverse
	end

	def combine_text(_txt)
		s = _txt
		letters = s.split(//)
	end

	def recombine_letters(_txt)
		s = _txt.downcase
		letters = s.split(//)
		len = _txt.length

		dict = {}
		for i in 1..len
			letters.permutation(i).each do |word|
				dict[word.join] = true
			end
		end

		puts "DEBUG: Generated " + dict.length.to_s + " permutations"

		matches = []
		File.open('./assets/words.txt').each_line do |line|
			line.chomp!
			matches << line if dict[line]
		end

		scores = {}
		matches.each do |word|
			scores[word] = calculate_word_score(word)
			puts word + ": " + scores[word].to_s + " points"
		end

		puts scores
		sorted_scores = scores.sort_by{|k,v|v}.reverse[0..9]
		puts sorted_scores

		return sorted_scores 

	end

	def calculate_word_score(_word)

		# this should be defined somewhere outside
		score_hash = {
			"a" => 1,
			"b" => 3,
			"c" => 3,
			"d" => 2,
			"e" => 1,
			"f" => 4,
			"g" => 2,
			"h" => 4,
			"i" => 1,
			"j" => 8,
			"k" => 5,
			"l" => 1,
			"m" => 3,
			"n" => 1,
			"o" => 1,
			"p" => 3,
			"q" => 10,
			"r" => 1,
			"s" => 1,
			"t" => 1,
			"u" => 1,
			"v" => 4,
			"w" => 4,
			"x" => 8,
			"y" => 4,
			"z" => 10
		}

		score = 0

		_word.each_char do |c|
			score += score_hash[c]
		end
		
		return score

	end

end




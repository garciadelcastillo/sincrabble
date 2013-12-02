# Scrabble Solver app
# by Jose Luis Garcia del Castillo

require 'sinatra'
require 'sinatra/reloader' if development?
require 'benchmark'
require './server/helpers.rb'

# HOME route
get '/' do 
	erb :index
end

# Main POST action
post '/solve' do
	solution = solve_scrabble(params[:letters])

	@clean_query = solution[:clean_query]
	@number_of_permutations = solution[:permutations]
	@number_of_possible_words = solution[:number_of_possible_words]
	@top_ten_words = solution[:top_ten_words]

	erb :scrabbled
end

# A fallback GET for the '/solve' route
get '/solve' do
	redirect to('/')
end

get '/test' do
	test
end

get '/test2' do
	test2
end

# Custom 404
not_found do
	status 404  
	'Page not found, sorry! XD'  
end 


helpers do

	def solve_scrabble(_query)

		clean_query = _query.downcase.tr('^a-z', '')  # clean the input string from non-letter inputs 
		letters = clean_query.split(//)

		# generate all posible permutations of the given letters
		# --> this block gets really expensive beyond 9 chars, should be optimized
		puts "DEBUG: Calculating permutations with RUBY PERMUTATION method: "
		perm = {} 
		puts Benchmark.measure {
			for i in 1..clean_query.length
				letters.permutation(i).each do |word|
					perm[word.join] = true
				end
			end
		}

		# parse the dictionary file for correct english words
		puts "DEBUG: Performing HASH LOOKUP: "
		words = [] 
		puts Benchmark.measure {
			File.open('./assets/words.txt').each_line do |line|
				line.chomp!
				words << line if perm[line]
			end
		}

		# AN ATTEMPT TO MAKE IT FASTER, ONLY REDUCED TIME TO AROUND 1/2

		# puts "DEBUG: Calculating permutations with CUSTOM PERMUTE method: "
		# @perm = {}
		# puts Benchmark.measure {

		# 	def permute(_base, _letters, _len) 
		# 		len = _len - 1

		# 		for i in 0..len
		# 			s = _base + _letters[i]
		# 			@perm[s] = true
		# 			_lett = Array.new(_letters)
		# 			_lett.delete_at(i)
		# 			permute(s, _lett, len)
		# 		end

		# 	end
			
		# 	permute('', letters, letters.length)
		# }

		# # parse the dictionary file for correct english words
		# puts "DEBUG: Performing HASH LOOKUP: "
		# words = [] 
		# puts Benchmark.measure {
		# 	File.open('./assets/words.txt').each_line do |line|
		# 		line.chomp!
		# 		words << line if @perm[line]
		# 	end
		# }

		# calculate scrabble score for each word
		scores = {}
		words.each do |word|
			scores[word] = calculate_word_score(word)
		end
		top_ten_words = scores.sort_by{|k,v|v}.reverse[0..9]

		# return a hash with output info
		return { 
			clean_query: clean_query,
			permutations: perm.length,
			number_of_possible_words: words.length,
			top_ten_words: top_ten_words
			}

	end

	def calculate_word_score(_word)

		score = 0

		_word.each_char do |c|
			score += SCORE_HASH[c]
		end
		
		return score

	end

	def test

		clean_query = 'abcdefghij'
		letters = clean_query.split(//)

		puts "DEBUG: creating permutation through file parsing: "
		words = []
		puts Benchmark.measure {
			File.open('./assets/perm.txt').each_line do |line|
				s = ''
				line.chomp!
				line.each_char { |c| s << letters[c.to_i] }
				words << s
			end
		}

	end	

	def test2

		# generate all posible permutations of the given letters
		puts "DEBUG: Generating permutations and saving them to file: "
		perm = {} 
		puts Benchmark.measure {

			@f = File.new('./assets/perm.txt', 'w')

			def permute(_base, _ints, _len) 

				len = _len - 1
				for i in 0..len
					s = _base + _ints[i].to_s
					@f.puts(s)
					_remainder = Array.new(_ints)
					_remainder.delete_at(i)
					permute(s, _remainder, len)
				end

			end

			ints = [0, 1, 2, 3, 4, 5, 6, 7, 8]
			
			permute('', ints, ints.length)

			@f.close

		}

	end

end

SCORE_HASH = {
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
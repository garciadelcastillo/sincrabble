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
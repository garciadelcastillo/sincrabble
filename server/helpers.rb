helpers do

	def solve_scrabble(_query)

		clean_query = _query.downcase.tr('^a-z', '')  # clean the input string from non-letter inputs 
		letters = clean_query.split(//)

		# generate all posible permutations of the given letters
		# --> this block gets really expensive beyond 9 chars, should be optimized
		perm = {} 
		for i in 1.._query.length
			letters.permutation(i).each do |word|
				perm[word.join] = true
			end
		end

		# parse the dictionary file for correct english words
		words = [] 
		File.open('./assets/words.txt').each_line do |line|
			line.chomp!
			words << line if perm[line]
		end

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
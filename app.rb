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

# Custom 404
not_found do
	status 404  
	'Page not found, sorry! XD'  
end 

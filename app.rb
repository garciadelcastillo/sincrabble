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
	@query = reverse_text(params[:letters])
	@letters = combine_text(params[:letters])
	# puts @letters
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





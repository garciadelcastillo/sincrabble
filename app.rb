
require 'sinatra'
require 'sinatra/reloader' if development?

# home route
get '/' do 
	"Welcome to the DMC's Scrabble Solver!"
end

# test params route
get '/sayhi/:name' do
	"Hi #{params[:name]}!"
end

get '/form' do
	erb :form
end

post '/form' do
	"You said '#{params[:message]}' " +
	"Reversed message is: #{reverse_text(params[:message])}"
end

not_found do  
	status 404  
	'Page not found, sorry!'  
end  


def reverse_text(_txt)

	_txt.reverse

end

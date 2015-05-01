require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'

set :database, "sqlite3:signup.sqlite3"
set :sessions, true
use Rack::Flash, sweep: true

#get displays information -> places request to server to 'get' information
#post = new -> changes something on the internet
#delete -self explanitory

get '/' do
	@user = User.all
	erb :home
end

get '/signup' do
	erb :signup
end
#/signup is just the page with the sign up form
#can use User.create also

post '/signup' do
	@user = User.new(params[:user])
	if @user.save
		redirect '/'
		flash[:notice] = 'Thanks for joining!'
	else
		redirect '/signup'
		flash[:alert] = 'Something went wrong :('
	end

end

get '/login' do
	erb :login
end

post '/login' do
	@user = User.find_by_email(params[:email])
	if @user && @user.password == params[:password]
		flash[:notice] = "You've logged in!"
		redirect to('/')
	else
		flash[:alert] = "there's something wrong"
		redirect to('/login')
	end
	
end
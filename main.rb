require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'

set :database, "sqlite3:signup.sqlite3"
set :sessions, true
use Rack::Flash, sweep: true

def current_user
	session[:user_id] ? User.find(session[:user_id]) : nil
end

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
		session[:user_id] = new_user.id
		flash[:notice] = 'Thanks for joining!'
		redirect '/'
	else
		flash[:alert] = 'Something went wrong :('
		redirect '/signup'
	end

end

get '/login' do
	erb :login
end

post '/login' do
	user = User.find_by_email(params[:email])
	if user && user.password == params[:password]
		session[:user_id] = user.id
		flash[:notice] = "You've logged in!"
		redirect to('/')
	else
		flash[:alert] = "there's something wrong"
		redirect to('/login')
	end
	
end

get '/logout' do
    session[:user_id] = nil
    flash[:alert] = "You have logged out!"
    redirect to('/')
end
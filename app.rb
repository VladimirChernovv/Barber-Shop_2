require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :main
end

post '/' do
  @main_login = params[:main_login]
  @main_password = params[:main_password]

  if @main_login == 'admin' && @main_password == 'secret161'
    erb :welcome
  else
    erb :error
  end
  
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

post '/visit' do
  @user_name = params[:user_name]
  @user_phone_number = params[:user_phone_number]
  @datetime = params[:datetime]
  @barber = params[:barber]

  @notification = "Thank you."
  @notification_title = "Dear #{@user_name} we'll be wating for you at #{@datetime}."

  notebook = File.open './publick/notebook.txt', 'a'
  notebook.write "User: #{@user_name}, Phone: #{@user_phone_number}, Barber: #{@barber} Date: #{@datetime}\n"
  notebook.close

  erb :notification
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  @email = params[:email]
  @user_message = params[:user_message]

  customer_data = File.open './publick/customer_data.txt', 'a'
  customer_data.write "User email: #{@email}, User message: #{@user_message}\n"
  customer_data.close

  erb :contacts
end
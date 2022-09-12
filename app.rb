require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb "Hello! <a href="" >Original</a>"
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

  @notification = "Thank you."
  @notification_title = "Dear #{@user_name} we'll be wating for you at #{@datetime}."

  notebook = File.open './publick/notebook.txt', 'a'
  notebook.write "User: #{@user_name}, Phone: #{@user_phone_number}, Date: #{@datetime}\n"
  notebook.close

  erb :notification
end

get '/contacts' do
  erb :contacts
end
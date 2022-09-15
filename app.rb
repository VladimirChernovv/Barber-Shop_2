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
  @user_phone = params[:user_phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]

  hh = {
    :user_name => 'Enter your name',
    :user_phone => 'Enter phone number',
    :datetime => 'Enter date and time'
  }

  # для каждой пары ключ-значение
  hh.each do |key, value|
    # если параметр пуст
    if params[key] == ''
      # переменной error присвоить value из хэша hh
      # (а value из хэша hh это сообщение об ошибке)
      # т.е. переменной error присвоить сообщение об ошибке
      @error = hh[key]

      # вернуть представление visit
      return erb :visit
    end
  end

  @notification = "Thank you."
  @notification_title = "Dear #{@user_name} we'll be wating for you at #{@datetime}. Your barber #{@barber} is booked. You choose color - #{@color}"

  notebook = File.open './public/notebook.txt', 'a'
  notebook.write "User: #{@user_name}, Phone: #{@user_phone}, Barber: #{@barber}, Date: #{@datetime}, Color: #{@color}\n"
  notebook.close

  erb :notification
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  @email = params[:email]
  @user_message = params[:user_message]

  customer_data = File.open './public/customer_data.txt', 'a'
  customer_data.write "User email: #{@email}, User message: #{@user_message}\n"
  customer_data.close

  erb :contacts
end
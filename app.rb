require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  # Создаём новое подключение к БД(barber_shop.db)
  # Если этот файл есть, то БД будет открыта
  # Если файла нет, он будет создан в текущем каталоге приложения
  @db = SQLite3::Database.new 'barber_shop.db'

  # Выполняем команду для создания таблицы
  @db.execute 'CREATE TABLE IF NOT EXISTS
    "Users"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "user_name" TEXT,
      "user_phone" TEXT,
      "date_stamp" TEXT,
      "barber" TEXT,
      "color" TEXT
    )
  '
end

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
  @date_stamp = params[:date_stamp]
  @barber = params[:barber]
  @color = params[:color]

  warnings = {
    :user_name => 'Enter your name',
    :user_phone => 'Enter phone number',
    :date_stamp => 'Enter date and time'
  }

  @error = warnings.select {|key, _| params[key] == ''}.values.join(", ")

  if @error != ""
    return erb :visit
  end

  @notification = "Thank you."
  @notification_title = "Dear #{@user_name} we'll be wating for you at #{@date_stamp}. Your barber #{@barber} is booked. You choose color - #{@color}"

  notebook = File.open './public/notebook.txt', 'a'
  notebook.write "User: #{@user_name}, Phone: #{@user_phone}, Barber: #{@barber}, Date: #{@date_stamp}, Color: #{@color}\n"
  notebook.close

  erb :notification
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  require 'pony'  

  @email = params[:email]
  @user_message = params[:user_message]
  my_email = "dgudo73@gmail.com"
  password = File.read './public/password_for_pony.txt', 16

  warnings = {
    :email => 'Enter your email',
    :user_message => 'Write a message'
  }

  @error = warnings.select {|key,_| params[key] == ''}.values.join(", ")

  if @error != ""
    return erb :contacts
  end

  Pony.mail(
    body: @user_message,
    to: @email,
    from: @my_email,
    via: :smtp,
    via_options: {
      address: 'smtp.gmail.com',
      port: '587',
      enable_starttls_auto: true,
      user_name: my_email,
      password: password,
      authentication: :plain
    }
  )

  customer_data = File.open './public/customer_data.txt', 'a'
  customer_data.write "User email: #{@email}, User message: #{@user_message}\n"
  customer_data.close

  @notification = "Thank you!"
  @notification_title = "The message was successfully sent."

  erb :notification
end
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb "Hello! <a href="" >Original</a>"
end

get '/about' do
  erb :about
end
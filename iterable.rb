#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'smarter_csv'
require 'httparty'
require 'dotenv'
require 'pp'

Dotenv.load
$options = {}
$options[:bulk] = false
$options[:file_path] = "users.csv"
#API key can be specified in .env file or passed in as an option
$options[:api_key] = ENV["ITERABLE_API_KEY"]
$users = []

class Iterable
  include HTTParty
  base_uri 'https://api.iterable.com/api'
  default_params api_key: $options[:api_key]
end

parser = OptionParser.new do |opts|
  opts.banner = "Usage: iterable.rb [$options]"
  opts.on("-b","--bulk", "perform bulk update") do 
    $options[:bulk] = true
    p 'bulk'
  end

  opts.on("-k","--key KEY", "specify api key") do |key|
    p key
    $options[:api_key] = key
  end

  opts.on("-f","--file path", "specify path to users file") do |path|
    p path
    $options[:file_path] = path
  end
end.parse!

def load_csv
  csv = SmarterCSV.process($options[:file_path])

  csv.each do |user|
    user_obj = Hash.new
    user_obj[:email] = user[:email]
    user.delete(:email)
    user_obj[:dataFields] = user
    $users << user_obj
  end
end

#bulk update
def update_users_bulk
  users = $users[1,3].to_json
  pp users
end

#individual updates
def update_users
  $users.each do |user|
    update_user(user)
  end
end

def update_user(user)
  p "Updating user: #{user}"
  resp = Iterable.post("/users/update", {body: user.to_json})
  p resp.code
end

load_csv
if $options[:bulk]
  update_users_bulk
else
  update_users
end



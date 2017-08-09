#!/usr/bin/env ruby

require 'optparse'
require 'smarter_csv'
require 'httparty'
require 'dotenv'
require 'progressbar'

Dotenv.load
$options = {}
$options[:bulk] = true 
$options[:file_path] = "users.csv"
#API key can be specified in .env file or passed in as an option
$options[:api_key] = ENV["ITERABLE_API_KEY"]
$options[:verbose] = false
$bar = ProgressBar.create format: "%a %e %P% [%B]"

class Iterable
  include HTTParty
  base_uri 'https://api.iterable.com/api'
  default_params api_key: $options[:api_key]
end

def log(msg)
  $bar.log msg if $options[:verbose]
end

parser = OptionParser.new do |opts|
  opts.banner = "Usage: iterable.rb [$options]"
  opts.on("-b","--bulk", "perform bulk update") do 
    $options[:bulk] = true
  end

  opts.on("-k","--key KEY", "specify api key") do |key|
    log "custom api key specified via flag: #{key}"
    $options[:api_key] = key
  end

  opts.on("-f","--file path", "specify path to users file") do |path|
    log "custom csv path specified: #{path}"
    $options[:file_path] = path
  end

  opts.on("-v","--verbose", "log everything") do
    $options[:verbose] = true
  end
end.parse!

def load_csv
  users = []
  csv = SmarterCSV.process($options[:file_path])
  csv.each do |user|
    user_obj = Hash.new
    user_obj[:email] = user[:email]
    user.delete(:email)
    user_obj[:dataFields] = user
    users << user_obj
  end
  return users
end

#bulk update
def update_users_bulk
  log "Updating users in bulk"
  users = load_csv
  $bar.total = users.length / 50
  users.each_slice(50) do |slice|
    resp = Iterable.post("/users/bulkUpdate", {body: slice.to_json})
    $bar.increment
    log "#{resp.code}: #{resp.parsed_response["code"]} (#{resp.parsed_response["msg"]})"
  end
end

#individual updates
def update_users
  users = load_csv
  $bar.total = users.length
  users.each do |user|
    $bar.increment
    update_user(user)
  end
end

def update_user(user)
  log "Updating user: #{user[:email]}"
  resp = Iterable.post("/users/update", {body: user.to_json})
  log "#{resp.code}: #{resp.parsed_response["code"]} (#{resp.parsed_response["msg"]})"
end

if $options[:bulk]
  update_users_bulk
else
  update_users
end


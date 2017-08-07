usr/bin/env ruby

require 'rubygems'
require 'commander/import'

program :name, 'update_users'
program :version, '0.0.1'
program :description, 'Updates users on iterable from a local CSV with  options to pass sample API payloads'

command :update, do |c|
  c.syntax = 'update_users update, [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Update_users::Commands::Update,
  end
end
require 'dotenv'
require 'smarter_csv'
require 'httparty'





Dotenv.load

class UpdateUsers
  ITERABLE_API_KEY = ENV['ITERABLE_API_KEY']
  USERS_FILE_PATH = "se_assignment_users.csv"

  def self.load_csv
    users = SmarterCSV.process(USERS_FILE_PATH)
    puts users
  end

  def self.build_request

  end


  #bulk update
  def self.update_users_bulk

  end

  #individual updates
  def self.update_users
    load_csv
  end
end

if ARGV.include?("bulk")
  UpdateUsers.update_users_bulk
else
  UpdateUsers.update_users
end


require 'bundler/setup'
require 'mysql2'
require_relative '../env.rb'

def _client
  Mysql2::Client.new(
    socket: '/var/run/mysqld/mysqld.sock', username: 'danoni-bot', password: _password, encoding: 'utf8', database: 'danoni'
  )
end

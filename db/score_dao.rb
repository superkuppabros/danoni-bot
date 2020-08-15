require 'bundler/setup'
require 'mysql2'
require_relative './client.rb'

class ScoreDao
  def get_random_works
    results = _client.query('SELECT DISTINCT page_url, title, adjustment from score_list;')

    results.to_a.sample
  end
end

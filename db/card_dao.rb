require 'bundler/setup'
require 'mysql2'
require_relative './client.rb'

class CardDao
  def get_random_card
    results = _client.query('select * from card_list')

    counter = 0
    results.each do |row|
      counter += row['possibility'].to_i
      row['weight'] = counter
    end

    random = rand(counter)
    results.detect { |row| random < row['weight'] }
  end
end

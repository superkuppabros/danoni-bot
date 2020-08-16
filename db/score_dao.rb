require 'bundler/setup'
require 'mysql2'
require_relative './client.rb'

class ScoreDao
  def get_random_works
    results = _client.query('SELECT DISTINCT page_url, title, adjustment from score_list;')

    results.to_a.sample
  end

  def get_details(title, creator, key_type, level_name)
    sql = %(
      SELECT duration, difficulty FROM score_list
        WHERE title = ?
        AND creator = ?
        AND key_type = ?
        AND level_name = ?
    )
    stmt = _client.prepare(sql)
    stmt.execute(title, creator, key_type, level_name)
  end
end

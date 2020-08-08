require 'bundler/setup'
require 'mysql2'
require_relative './client.rb'

class TournamentDao
  def init
    _client.query('DROP TABLE IF EXISTS tournament_member')
    _client.query(
      'CREATE TABLE tournament_member(
        id INT NOT NULL AUTO_INCREMENT,
        display_name VARCHAR(64) UNIQUE NOT NULL,
        league INT DEFAULT 0,
        PRIMARY KEY (id)
      )'
    )

    _client.query('DROP TABLE IF EXISTS tournament')
    _client.query(
      'CREATE TABLE tournament(
        id INT NOT NULL AUTO_INCREMENT,
        league INT NOT NULL,
        winner VARCHAR(64) NOT NULL,
        loser VARCHAR(64) NOT NULL,
        PRIMARY KEY (id)
      )'
    )
  end

  def add_member(name)
    sql = %{
      INSERT INTO tournament_member(display_name) VALUES(?)
    }
    stmt = _client.prepare(sql)
    stmt.execute(name)
  end

  def delete_member(name)
    sql = %(
      DELETE FROM tournament_member where display_name = ?
    )
    stmt = _client.prepare(sql)
    stmt.execute(name)
  end

  def get_all_members
    _client.query('SELECT * FROM tournament_member ORDER BY league ASC')
  end

  def get_league_members_name(league)
    sql = %(
      SELECT display_name FROM tournament_member where league = ? ORDER BY id ASC
    )
    stmt = _client.prepare(sql)
    stmt.execute(league)
  end

  def update_league(league, name)
    sql = %(
      UPDATE tournament_member SET league = ? where display_name = ?
    )
    stmt = _client.prepare(sql)
    stmt.execute(league, name)
  end

  def add_game(league, winner, loser)
    sql = %{
      INSERT INTO tournament(league, winner, loser) VALUES (?, ?, ?)
    }
    stmt = _client.prepare(sql)
    stmt.execute(league, winner, loser)
  end

  def get_result(league)
    sql = %(
      SELECT winner,loser FROM tournament WHERE league = ?
    )
    stmt = _client.prepare(sql)
    stmt.execute(league)
  end
end

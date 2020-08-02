require_relative('../db/tournament_dao')

class TournamentService
  @dao = TournamentDao.new

  def self.init
    @dao.init
  end

  def self.add_member(name)
    @dao.add_member(name)
  end

  def self.delete_member(name)
    @dao.delete_member(name)
  end

  def self.all_members
    @dao.get_all_members
  end

  # arg: '/team N m1 m2...'
  # N = a number of members
  # m_i = member's name
  # @param line [String]
  def self.divide_team_from_string(line)
    members = line.split(' ')
    _ = members.shift
    team_num = members.shift.to_i
    members.shuffle!
    members.group_by.with_index { |_, i| i % team_num }.values
  end

  def self.divide(league_num)
    members = @dao.get_all_members.map { |member| member['display_name'] }
    members.shuffle!
    leagues = members.group_by.with_index { |_, i| i % league_num } .values
    leagues.each_with_index do |league, index|
      league.each { |name| @dao.update_league(index + 1, name) }
    end

    leagues
  end

  def self.add_game(league, winner, loser)
    @dao.add_game(league, winner, loser)
  end

  def self.get_result(league)
    @dao.get_result(league)
  end
end

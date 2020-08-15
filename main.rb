require 'bundler/setup'
require 'discordrb'
require_relative './service/result_service.rb'
require_relative './service/tournament_service.rb'
require_relative './db/card_dao.rb'
require_relative './db/score_dao.rb'
require_relative './env.rb'

bot = Discordrb::Bot.new token: _bot_token
bot.message(contains: '#danoni') do |event|
  result_service = ResultService.new
  author = event.author.display_name.to_s
  return_message = "プレイヤー: #{author}\n" + result_service.analyse(event.message.to_s)
  event.respond return_message
end

bot.message(content: 'chance') do |event|
  database_service = CardDao.new
  author =
    if event.author.class == Discordrb::Recipient
      event.author.username.to_s
    elsif event.author.class == Discordrb::Member
      event.author.display_name.to_s
    else
      'danoni'
    end
  card = database_service.get_random_card
  return_message = "#{author}さんのカード: [#{card['attribute']}]#{card['name']}\n#{card['explanation']}"
  event.respond return_message
end

bot.message(content: 'random') do |event|
  dao = ScoreDao.new
  works = dao.get_random_works
  return_message = "曲名: #{works['title']}
URL: #{works['page_url']}
補正値: #{works['adjustment']}"

  event.author.pm(return_message)
end

bot.message(start_with: '/team') do |event|
  teams = TournamentService.divide_team_from_string(event.message.to_s)
  return_message = teams.each_with_index.reduce('') { |message, (members, index)| "#{message}チーム#{index + 1}: #{members.join(', ')}\n" }
  event.respond return_message
end

bot.message(start_with: '/initialize') do |event|
  if event.message.to_s.split(' ')[1] == _password
    TournamentService.init
    event.respond 'データを初期化しました。'
  else
    event.respond 'The operation is not allowed.'
  end
end

bot.message(content: '参加します') do |event|
  TournamentService.add_member(event.author.display_name.to_s)
  event.respond "#{event.author.display_name}さんが参加しました。"
end

bot.message(start_with: '/join') do |event|
  name = event.message.to_s.split(' ')[1]
  TournamentService.add_member(name)
  event.respond "#{name}さんが参加しました。"
end

bot.message(start_with: '/delete') do |event|
  name = event.message.to_s.split(' ')[1]
  TournamentService.delete_member(name)
  event.respond "#{name}さんの参加をキャンセルしました。"
end

bot.message(start_with: '/divide') do |event|
  if event.message.to_s.split(' ')[2] == _password
    teams = TournamentService.divide(event.message.to_s.split(' ')[1].to_i)
    return_message = teams.each_with_index.reduce('') { |message, (members, index)| "#{message}リーグ#{index + 1}: #{members.join(', ')}\n" }
    event.respond return_message
  else
    event.respond 'The operation is not allowed.'
  end
end

bot.message(content: '/show_members') do |event|
  members = TournamentService.all_members.map { |member| "#{member['display_name']} リーグ: #{member['league']}" }
  event.respond "参加者一覧\n" + members.join("\n")
end

bot.message(start_with: '/game') do |event|
  arr = event.message.to_s.split(' ')
  league = arr[1].to_i
  winner = arr[2]
  loser = arr[3]
  TournamentService.add_game(league, winner, loser)
  event.respond '結果を登録しました。'
end

bot.message(start_with: '/result') do |event|
  league = event.message.to_s.split(' ')[1].to_i
  result = TournamentService.get_result(league).map { |game| "○#{game['winner']}-#{game['loser']}×" }
  event.respond "リーグ#{league}の結果\n" + result.join("\n")
end

bot.message(start_with: '/next_game') do |event|
  arr = event.message.to_s.split(' ')
  league = arr[1].to_i
  sets = arr[2].to_s.split('').each_slice(2).to_a
  game_name = arr[3].to_s || ''
  members_name = TournamentService.league_members_name(league).to_a
  match_strs = sets.map do |set|
    "・#{members_name[(set[0].to_i - 1)]['display_name']}さん vs #{members_name[(set[1].to_i - 1)]['display_name']}さん"
  end
  result_message = "リーグ#{league} #{game_name}を開始します。\n#{match_strs.join("\n")}\n準備はよろしいですか？"
  event.respond result_message
end

bot.run

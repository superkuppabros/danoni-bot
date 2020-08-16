require_relative('../db/score_dao')

class ResultService
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # @param line [String]
  def analyse(line)
    items = line.split('/')
    title_reg_exp = %r{^【.*?】(.*?)[/\(](.*?)k-(.*?)(?:\)\s)?/}
    header = title_reg_exp.match(line.to_s).to_a
    title = header[1]
    key_type = header[2]
    level_name = header[3]

    # MFV2's source
    if items[4].split('-').length == 5
      score = items[7].delete('Sco').split('-')[1].to_i
      note_judges = items[4].split('-').map(&:to_i)
      freeze_judges = items[5].split('-').map(&:to_i)
      combo_judges = items[6].delete('Mc').split('-').map(&:to_i)
      creator = items[2].to_s
    else
      score = items[3].split(':')[1]
      note_judges = items[5].split('-').map(&:to_i)
      freeze_judges = items[6].split('-').map(&:to_i)
      combo_judges = items[7].split('-').map(&:to_i)
      creator = items[1].to_s.split(' ')[0]
    end

    special_target_str = judge_special_target(title, creator, key_type, level_name)

    result_data = {
      'ii' => note_judges[0],
      'syakin' => note_judges[1],
      'matari' => note_judges[2],
      'shobon' => note_judges[3],
      'uwan' => note_judges[4],
      'kita' => freeze_judges[0],
      'ikunai' => freeze_judges[1],
      'maxcombo' => combo_judges[0],
      'frzcombo' => combo_judges[1],
      'score' => score
    }

    recover_notes_num = result_data['ii'] + result_data['syakin']
    recover_freezes_num = result_data['kita']
    recover_num = recover_notes_num + recover_freezes_num
    matari_num = result_data['matari']
    miss_num = result_data['shobon'] + result_data['uwan'] + result_data['ikunai']
    accuracy = (recover_num.fdiv(recover_num + matari_num + miss_num) * 100).round(2)
    combo = result_data['maxcombo'] + result_data['frzcombo']

    result_message = "素点: #{recover_num} (#{recover_notes_num}+#{recover_freezes_num}) #{special_target_str}
マターリ数: #{matari_num} ミス数: #{miss_num}, 達成率: #{accuracy}%, コンボ数: #{combo}"

    result_message
  end

  def judge_special_target(title, creator, key_type, level_name)
    dao = ScoreDao.new
    record = dao.get_details(title, creator, key_type, level_name).to_a

    res_str = ''
    if record.length == 1
      res_str += '[Short]' if record[0]['duration'].to_i < 120
      res_str += '[Easy]' if record[0]['difficulty'].to_f < 10
    end
    res_str
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
end

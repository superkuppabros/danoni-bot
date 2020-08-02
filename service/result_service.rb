class ResultService
  # rubocop:disable Metrics/AbcSize
  # @param line [String]
  def analyse(line)
    items = line.split('/')
    score = items[3].split(':')[1]
    note_judges = items[5].split('-').map(&:to_i)
    freeze_judges = items[6].split('-').map(&:to_i)
    combo_judges = items[7].split('-').map(&:to_i)

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

    recover_num = result_data['ii'] + result_data['syakin'] + result_data['kita']
    matari_num = result_data['matari']
    miss_num = result_data['shobon'] + result_data['uwan'] + result_data['ikunai']
    accuracy = recover_num.fdiv(recover_num + matari_num + miss_num).round(4) * 100
    combo = result_data['maxcombo'] + result_data['frzcombo']

    result_message = "素点: #{recover_num}
ミス数: #{miss_num}, 達成率: #{accuracy}%, コンボ数: #{combo}"

    result_message
  end

  # rubocop:enable Metrics/AbcSize
end

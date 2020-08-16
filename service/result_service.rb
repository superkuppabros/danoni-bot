class ResultService
  # rubocop:disable Metrics/AbcSize
  # @param line [String]
  def analyse(line)
    items = line.split('/')

    # MFV2's source
    if items[4].split('-').length == 5
      score = items[7].delete('Sco').split('-')[1].to_i
      note_judges = items[4].split('-').map(&:to_i)
      freeze_judges = items[5].split('-').map(&:to_i)
      combo_judges = items[6].delete('Mc').split('-').map(&:to_i)
    else
      score = items[3].split(':')[1]
      note_judges = items[5].split('-').map(&:to_i)
      freeze_judges = items[6].split('-').map(&:to_i)
      combo_judges = items[7].split('-').map(&:to_i)
    end

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

    result_message = "素点: #{recover_num} (#{recover_notes_num}+#{recover_freezes_num})
マターリ数: #{matari_num} ミス数: #{miss_num}, 達成率: #{accuracy}%, コンボ数: #{combo}"

    result_message
  end

  # rubocop:enable Metrics/AbcSize
end

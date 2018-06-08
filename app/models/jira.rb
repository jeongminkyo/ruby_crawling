class Jira < ApplicationRecord

  SEARCH_CATEGORY = {
      'REQTS_num' => '1',
      'title' => '2',
      'assignee' => '3',
      'reporter' => '4'
  }

  def self.change_string_to_time(time_str)
    Time.parse("#{time_str['year']}-#{time_str['month']}-#{time_str['day']}").strftime('%Y-%m-%d')
  end
end

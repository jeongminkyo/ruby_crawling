
task insert_db_first: :environment do
  mechanize = Mechanize.new

  page = mechanize.get('https://jira.nbt.com/login.jsp')
  page.forms[1].field_with(:name => 'os_username').value = ''
  page.forms[1].field_with(:name => 'os_password').value = ''
  page.forms[1].submit

  arr = []
  for i in (0..2)
    if i.zero? ? url = 'https://jira.nbt.com/issues/?jql=project%20%3D%20REQTS' : url = 'https://jira.nbt.com/issues/?jql=project%20%3D%20REQTS&startIndex=' + (50*i).to_s
      page = mechanize.get(url)
    end

    doc = page.parser

    doc.css('#issuetable').css('tbody').css('tr').each do |x|
      if Jira.last.present?
        if x.css('.issuekey').css('.issue-link').text > Jira.last.num
          hash = {}
          hash['reqts_num'] = x.css('.issuekey').css('.issue-link').text
          hash['title'] = x.css('.summary').css('.issue-link').text
          hash['assignee'] = x.css('.assignee').css('.user-hover').text
          hash['reporter'] = x.css('.reporter').css('.user-hover').text
          hash['status'] = x.css('.status').css('span').text
          hash['created'] = x.css('.created').css('time').text
          arr.push(hash)
        end
      else
        hash = {}
        hash['reqts_num'] = x.css('.issuekey').css('.issue-link').text
        hash['title'] = x.css('.summary').css('.issue-link').text
        hash['assignee'] = x.css('.assignee').css('.user-hover').text
        hash['reporter'] = x.css('.reporter').css('.user-hover').text
        hash['status'] = x.css('.status').css('span').text
        hash['created'] = x.css('.created').css('time').text
        arr.push(hash)
      end
    end
  end

  arr = arr.sort_by { |hsh| hsh['reqts_num'] }

  arr.each do |arr|
    Jira.create(num: arr['reqts_num'], title: arr['title'],
                assignee: arr['assignee'], reporter: arr['reporter'],
                status: arr['status'], created: arr['created'].to_datetime.strftime('%Y-%m-%d'))
  end
end


task insert_db: :environment do
  mechanize = Mechanize.new

  page = mechanize.get('https://jira.nbt.com/login.jsp')
  page.forms[1].field_with(:name => 'os_username').value = ''
  page.forms[1].field_with(:name => 'os_password').value = ''
  page.forms[1].submit

  arr = []
  url = 'https://jira.nbt.com/issues/?jql=project%20%3D%20REQTS'
  page = mechanize.get(url)

  doc = page.parser

  doc.css('#issuetable').css('tbody').css('tr').each do |x|
    if x.css('.issuekey').css('.issue-link').text > Jira.last.num
      hash = {}
      hash['reqts_num'] = x.css('.issuekey').css('.issue-link').text
      hash['title'] = x.css('.summary').css('.issue-link').text
      hash['assignee'] = x.css('.assignee').css('.user-hover').text
      hash['reporter'] = x.css('.reporter').css('.user-hover').text
      hash['status'] = x.css('.status').css('span').text
      hash['created'] = x.css('.created').css('time').text
      arr.push(hash)
    else
      reqts_num = x.css('.issuekey').css('.issue-link').text
      assignee = x.css('.assignee').css('.user-hover').text
      status = x.css('.status').css('span').text
      jira = Jira.find_by_num(reqts_num)

      unless jira.assignee == assignee
        jira.update(assignee: assignee)
      end
      unless jira.status == status
        jira.update(status: status)
      end
    end
  end

  arr = arr.sort_by { |hsh| hsh['reqts_num'] }

  arr.each do |arr|
    Jira.create(num: arr['reqts_num'], title: arr['title'],
                assignee: arr['assignee'], reporter: arr['reporter'],
                status: arr['status'], created: arr['created'].to_datetime.strftime('%Y-%m-%d'))
  end
end
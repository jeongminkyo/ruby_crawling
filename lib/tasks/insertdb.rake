
task insert_db_first: :environment do
  browser = Watir::Browser.start 'https://jira.nbt.com/login.jsp?os_destination=%2Fsecure%2FDashboard.jspa'
  t = browser.text_field(name: 'os_username')
  t.set ''
  browser.text_field(name: 'os_password').set ''
  browser.button(name: 'login').click

  arr = []
  for i in (0..2)
    if i.zero? ? url = 'https://jira.nbt.com/issues/?jql=project%20%3D%20REQTS' : url = 'https://jira.nbt.com/issues/?jql=project%20%3D%20REQTS&startIndex=' + (50*i).to_s
      browser.goto url
    end

    doc = Nokogiri::HTML.parse(browser.html)

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
  browser = Watir::Browser.start 'https://jira.nbt.com/login.jsp?os_destination=%2Fsecure%2FDashboard.jspa'
  t = browser.text_field(name: 'os_username')
  t.set ''
  browser.text_field(name: 'os_password').set ''
  browser.button(name: 'login').click

  arr = []
  url = 'https://jira.nbt.com/issues/?jql=project%20%3D%20REQTS'
  browser.goto url

  doc = Nokogiri::HTML.parse(browser.html)

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
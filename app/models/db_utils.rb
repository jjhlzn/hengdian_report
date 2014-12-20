require 'tiny_tds'

module DBUtils
  @@ticket_server = 'TicketServer'

  private
  def execute_array(sql)
    client = TinyTds::Client.new(:username => 'sa',
                                 :password => 'hdapp@)!@',
                                 :host => '10.1.87.110',
                                 :timeout => 60,
                                 :ANSI_NULLS => true,
                                 :ANSI_WARNINGS => true)
    client.execute('set   ansi_nulls   on')
    client.execute('set   ansi_warnings   on')
    result = client.execute(sql)
    array = []
    result.each do |row|
      array.push row
    end
    #关闭连接
    client.close
    return array
  end

  def ticket_server
    @@ticket_server
  end

  def get_ticket_database(date)
    'iccard' + (date.year % 100).to_s
  end

  def ticket_db_prefix(date)
    "#{ticket_server}.#{get_ticket_database(date)}.dbo"
  end
end
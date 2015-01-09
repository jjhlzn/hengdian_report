require 'tiny_tds'
require 'date'

module DBUtils
  #@@ticket_server = 'TicketServer'
  @@ticket_server = Rails.application.config.mssql_ticket_server

  private
  def get_client
    client = TinyTds::Client.new(:username => Rails.application.config.mssql_username,
                                 #:password => 'hdapp@)!@',
                                 :password => Rails.application.config.mssql_password,
                                 #:host => '10.1.87.110',
                                 :host => Rails.application.config.mssql_host,
                                 :timeout => 60,
                                 :ANSI_NULLS => true,
                                 :ANSI_WARNINGS => true)
    client.execute('set   ansi_nulls   on')
    client.execute('set   ansi_warnings   on')
    return client
  end

  def execute_query(sql)
    client = get_client()
    result = client.execute(sql)
    array = []
    result.each do |row|
      array.push row
    end
    #关闭连接12
    client.close
    return array
  end

  def execute_update(sql)
    client = get_client()
    result = client.execute(sql)
    result.do
    #关闭连接12
    client.close
  end

  def execute_insert(sql)
    client = get_client()
    result = client.execute(sql)
    result.insert
    #关闭连接12
    client.close
  end

  def ticket_server
    @@ticket_server
  end

  def get_ticket_database(date)
    'iccard' + (date.year % 100).to_s
  end

  def ticket_db_prefix(date_or_year)
    if (date_or_year.methods.grep /nonzero\?/).count == 0
      "#{ticket_server}.#{get_ticket_database(date_or_year)}.dbo"
    else
      "#{ticket_server}.#{get_ticket_database(DateTime.new(date_or_year,1,1))}.dbo"
    end

  end
end
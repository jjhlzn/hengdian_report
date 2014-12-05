require 'tiny_tds'

module DBUtils
  @@ticket_server = ''

  private
  def execute_array(sql)
    client = TinyTds::Client.new(:username => 'sa',
                                 :password => '123456',
                                 :host => '192.168.0.105

',
                                 :timeout => 60)
    result = client.execute(sql)
    array = []
    result.each do |row|
      array.push row
    end
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
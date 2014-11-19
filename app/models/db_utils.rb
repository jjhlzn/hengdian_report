require 'tiny_tds'

class DBUtils
  @@ticket_server = ''

  def self.execute_array(sql)
    client = TinyTds::Client.new(:username => 'sa',
                                 :password => '123456',
                                 :host => '10.1.36.168',
                                 :timeout => 60)
    result = client.execute(sql)
    array = []
    result.each do |row|
      array.push row
    end
    client.close
    return array
  end

  def self.ticket_server
    @@ticket_server
  end

  def self.get_ticket_database(date)
    'iccard' + (date.year % 100).to_s
  end
end
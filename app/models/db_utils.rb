require 'tiny_tds'

class DBUtils
  @@ticket_server = ''
  #def self.execute(sql)
  #  client = TinyTds::Client.new(:username => 'sa',
  #                               :password => '123456',
  #                               :host => '192.168.1.108')
  #  result = client.execute(sql)
  #  client.close
  #  return result
  #end

  def self.execute_array(sql)
    client = TinyTds::Client.new(:username => 'sa',
                                 :password => '123456',
                                 :host => '192.168.1.108',
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
end
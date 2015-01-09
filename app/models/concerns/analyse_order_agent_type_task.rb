class AnalyseOrderAgentTypeTask
  include NetworkOrderAnalyzer
  @@agent_types = {}

  def exec
    exec0(DateTime.now.year)
  end

  def init
    exec0(2013)
    exec0(2014)
    exec0(2015)
  end

  private
  def exec0(year)
    orders = get_all_orders(year)
    handle_orders(orders)
  end

  def handle_orders(orders)
    orders.each do |order|
      check_sql = <<-SQL
                  SELECT 1 FROM report.dbo.t_orderstatinfo WHERE sellid = '#{order['SellID']}'
      SQL
      insert_sql = <<-SQL
          INSERT INTO report.dbo.t_orderstatinfo (sellid, network_belong_to) VALUES ('#{order['SellID']}', '#{get_agent_type(order['DTravelNo'])}')
      SQL
      update_sql = <<-SQL
          UPDATE report.dbo.t_orderstatinfo SET network_belong_to = '#{get_agent_type(order['DTravelNo'])}' WHERE sellid = '#{order['SellID']}'
      SQL
      if (execute_query(check_sql).count > 0 )
        execute_update(update_sql)
      else
        execute_insert(insert_sql)
      end
    end
  end

  def load_agent_types()
    if @@agent_types.count == 0
      sql = <<-SQL
        SELECT * FROM hdbusiness.dbo.tbdAgentType
      SQL
      rs = execute_query(sql)
      rs.each do |row|
        @@agent_types[row['agentno']] = row['type']
      end
    end
  end

  def get_agent_type(agent_no)
    load_agent_types()
    type = @@agent_types[agent_no]
    type = '代理商' unless type
    return type
  end


end
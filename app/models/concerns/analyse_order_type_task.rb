class AnalyseOrderTypeTask
  include DBUtils
  include Hengdian
  include NetworkOrderAnalyzer
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
    exec0_ticket(year)
    exec0_hotel(year)
    exec0_packages(year)
  end

  def exec0_ticket(year)
    orders = get_ticket_orders(year)
    handle_orders(orders, ORDER_TYPE_TICKET)
  end

  def exec0_hotel(year)
    orders = get_hotel_orders(year)
    handle_orders(orders, ORDER_TYPE_HOTEL)
  end

  def exec0_packages(year)
    orders = get_package_orders(year)
    handle_orders(orders, ORDER_TYPE_HOTEL)
  end

  def handle_orders(orders, order_type)
    orders.each do |order|
      check_sql = <<-SQL
                  SELECT 1 FROM report.dbo.t_orderstatinfo WHERE sellid = '#{order['SellID']}'
      SQL
      insert_sql = <<-SQL
          INSERT INTO report.dbo.t_orderstatinfo (sellid, network_order_type) VALUES ('#{order['SellID']}', '#{order_type.name}')
      SQL
      update_sql = <<-SQL
          UPDATE report.dbo.t_orderstatinfo SET NETWORK_ORDER_TYPE = '#{order_type.name}' WHERE sellid = '#{order['SellID']}'
      SQL
      if (execute_query(check_sql).count > 0 )
        execute_update(update_sql)
      else
        execute_insert(insert_sql)
      end
    end
  end
end

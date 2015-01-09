module NetworkOrderAnalyzer
  include DBUtils
  include Hengdian

  private
  def get_all_orders(year)
    sql = <<-SQL
          SELECT a.* FROM #{ticket_db_prefix(year)}.v_tbdTravelOK a inner join
                   #{ticket_db_prefix(year)}.v_tbdTravelOkOther b on a.SellID = b.SellID
          WHERE EXISTS(SELECT b.DName FROM #{ticket_db_prefix(year)}.tbdGroupType b
                                WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType AND DGroupRoomType = '网络用房')
                AND NOT EXISTS (SELECT SellID FROM #{ticket_db_prefix(year)}.v_tbdTravelOkPro b WHERE a.SellID = b.SellID AND b.CurID = 'N1')
                AND DComeDate between '#{year}-1-01' and '#{year}-12-31'
                AND a.SellID NOT IN (SELECT SellID FROM report.dbo.t_orderstatinfo WHERE network_order_type is NOT NULL OR network_order_type <> '')
    SQL
    return execute_query(sql)
  end

  def get_ticket_orders(year)
    sql = <<-SQL
          SELECT a.* FROM #{ticket_db_prefix(year)}.v_tbdTravelOK a inner join
                   #{ticket_db_prefix(year)}.v_tbdTravelOkOther b on a.SellID = b.SellID
          WHERE EXISTS(SELECT b.DName FROM #{ticket_db_prefix(year)}.tbdGroupType b
                                WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType AND DGroupRoomType = '网络用房')
                AND NOT EXISTS (SELECT SellID FROM #{ticket_db_prefix(year)}.v_tbdTravelOkPro b WHERE a.SellID = b.SellID AND b.CurID = 'N1')
                AND DComeDate between '#{year}-1-01' and '#{year}-12-31'
                AND a.SellID NOT IN (SELECT SellID FROM report.dbo.t_orderstatinfo WHERE network_order_type is NOT NULL OR network_order_type <> '')
    SQL
    return execute_query(sql)
  end

  def get_hotel_orders(year)
    sql = <<-SQL
          SELECT a.* FROM #{ticket_db_prefix(year)}.v_tbdTravelOK a inner join
                   #{ticket_db_prefix(year)}.v_tbdTravelOkOther b on a.SellID = b.SellID
          WHERE EXISTS(SELECT b.DName FROM #{ticket_db_prefix(year)}.tbdGroupType b
                                WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType AND DGroupRoomType = '网络用房')
                AND EXISTS (SELECT SellID FROM #{ticket_db_prefix(year)}.v_tbdTravelOkPro b WHERE a.SellID = b.SellID AND b.CurID = 'N1')
                AND (SELECT COUNT(*) FROM #{ticket_db_prefix(year)}.v_tbdTravelOkPro b WHERE a.SellID = b.SellID AND AllowJdFlag = 0) = 1
                AND DComeDate between '#{year}-1-01' and '#{year}-12-31'
                AND a.SellID NOT IN (SELECT SellID FROM report.dbo.t_orderstatinfo WHERE network_order_type is NOT NULL OR network_order_type <> '')
    SQL
    return execute_query(sql)
  end

  def get_package_orders(year)
    sql = <<-SQL
          SELECT a.* FROM #{ticket_db_prefix(year)}.v_tbdTravelOK a inner join
                   #{ticket_db_prefix(year)}.v_tbdTravelOkOther b on a.SellID = b.SellID
          WHERE EXISTS(SELECT b.DName FROM #{ticket_db_prefix(year)}.tbdGroupType b
                                WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType AND DGroupRoomType = '网络用房')
                AND EXISTS (SELECT SellID FROM #{ticket_db_prefix(year)}.v_tbdTravelOkPro b WHERE a.SellID = b.SellID AND b.CurID = 'N1')
                AND (SELECT COUNT(*) FROM #{ticket_db_prefix(year)}.v_tbdTravelOkPro b WHERE a.SellID = b.SellID AND AllowJdFlag = 0) > 1
                AND DComeDate between '#{year}-1-01' and '#{year}-12-31'
                AND a.SellID NOT IN (SELECT SellID FROM report.dbo.t_orderstatinfo WHERE network_order_type is NOT NULL OR network_order_type <> '')
    SQL
    return execute_query(sql)
  end


end
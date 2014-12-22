require 'date'
require 'hengdian'

class DayReportScript
  include TSColumns
  include Hengdian::Contants
  include Hengdian
  include DBUtils
  include PieStyle

  def initialize
  end

  #获取指定日期的订单分析,这个只关心预订的情况,不关心订单的实际使用情况
  def get_order_stat(date=DateTime.now, indicator = INDICATOR_ORDER_COUNT)
    result = []
    [ORDER_TYPE_TICKET, ORDER_TYPE_HOTEL, ORDER_TYPE_PACKAGE].each_with_index do |x, index|
       result << {
                     id:   x.id,
                     label: x.name,
                     value: get_order_stat0(date, x, indicator).to_i,
                     color: @@colors[index]
                 }
    end
    return {datasets: result}
  end

  private
  def get_order_stat0(date, order_type, indicator)
    orders = execute_array(get_sql(date, order_type))
    case indicator
      when INDICATOR_ORDER_COUNT then
        orders.count
      when INDICATOR_PEOPLE_COUNT then
        (orders.map {|x| x[COL_ORDER_PEOPLE]}).reduce(0, :+)
      when INDICATOR_TOTAL_MONEY then
        (orders.map {|x| x[COL_ORDER_TOTAL_MONEY]}).reduce(0, :+)
      else
        raise "unkownn indicator"
    end
  end

  #type表示订单的类型, 0 = 全部订单, 1 = 单门票, 2 = 单酒店, 3 = 套餐
  def get_sql(date, order_type)
    case order_type
      when ORDER_TYPE_ALL then
        get_all_order_sql(date)
      when ORDER_TYPE_TICKET then
        get_ticket_order_sql(date)
      when ORDER_TYPE_HOTEL then
        get_hotel_order_sql(date)
      when ORDER_TYPE_PACKAGE then
        get_package_order_sql(date)
      else
        raise 'unknown order type'
    end
  end
  def get_all_order_sql(date)
    sql =  """SELECT * FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a
              WHERE DDate = '#{date.strftime('%F')}'
                    AND a.Flag in (0, 1)
                    AND EXISTS(SELECT * FROM #{ticket_db_prefix(date)}.tbdGroupType b
                               WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                                     AND DGroupRoomType = '网络用房')"""
    Rails.logger.debug { sql }
    return sql
  end

  def get_ticket_order_sql(date)
    sql =  """SELECT * FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a
              WHERE DDate = '#{date.strftime('%F')}'
              AND a.Flag in (0, 1)
              AND NOT EXISTS (SELECT SellID FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                              WHERE a.SellID = b.SellID AND b.CurID = 'N1')
              AND EXISTS(SELECT * FROM #{ticket_db_prefix(date)}.tbdGroupType b
                         WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                               AND DGroupRoomType = '网络用房')"""
    Rails.logger.debug { sql }
    return sql
  end

  def get_hotel_order_sql(date)
    sql =  """SELECT * FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a
              WHERE DDate = '#{date.strftime('%F')}'
              AND a.Flag in (0, 1)
              AND EXISTS (SELECT SellID FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                          WHERE a.SellID = b.SellID AND b.CurID = 'N1')
              AND (SELECT COUNT(*) FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                   WHERE a.SellID = b.SellID AND AllowJdFlag = 0 AND CurID != '05') = 1
              AND EXISTS(SELECT * FROM #{ticket_db_prefix(date)}.tbdGroupType b
                         WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                               AND DGroupRoomType = '网络用房')"""
    Rails.logger.debug { sql }
    return sql
  end

  def get_package_order_sql(date)
    sql =  """SELECT * FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a
              WHERE DDate = '#{date.strftime('%F')}'
              AND a.Flag in (0, 1)
              AND EXISTS (SELECT SellID FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                          WHERE a.SellID = b.SellID AND b.CurID = 'N1')
              AND (SELECT COUNT(*) FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                   WHERE a.SellID = b.SellID AND AllowJdFlag = 0) > 1
              AND EXISTS(SELECT * FROM #{ticket_db_prefix(date)}.tbdGroupType b
                         WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                               AND DGroupRoomType = '网络用房')"""
    Rails.logger.debug { sql }
    return sql
  end
end
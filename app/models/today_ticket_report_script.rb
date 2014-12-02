require 'hengdian'

class TodayTicketReportScript
  include TSColumns
  include DBUtils

  def get_topn_production(date, indicator, topn = 5)
    sql = get_topn_production_sql(date, indicator)
    result_sets = execute_array sql
    names = result_sets.map { |x| x[COL_PRO_NAME] }
    values = result_sets.map { |x| x[indicator].to_i }
    return {names: names, values: values}
  end

  private
  def get_topn_production_sql(date, indicator)
    ticket_db_name = get_ticket_database(DateTime.new(date.year, 1, 1))
    sql = """SELECT CurID,
                    (SELECT b.MyName FROM  #{ticket_server}.#{ticket_db_name}.dbo.tbdProduction b where c.CurID = b.CurID) as MyName,
                     SUM(DNumber) as people_count,
                     COUNT(distinct SellID) as order_count,
                     SUM(DAmount) as total_money
              FROM #{ticket_server}.#{ticket_db_name}.dbo.v_tbdTravelOkProDetail c
                    WHERE SellID in (
                    SELECT SellID FROM #{ticket_server}.#{ticket_db_name}.dbo.v_tbdTravelOk a
                    WHERE DComeDate = '#{date.strftime('%F')}'
                        AND Flag in (0, 1)
                          AND NOT EXISTS (SELECT SellID FROM #{ticket_server}.#{ticket_db_name}.dbo.v_tbdTravelOkPro b
                                          WHERE a.SellID = b.SellID AND b.CurID = 'N1')
                          AND EXISTS(SELECT * FROM #{ticket_server}.#{ticket_db_name}.dbo.tbdGroupType b
                                     WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                                           AND DGroupRoomType = '网络用房'))
                    GROUP BY CurID
                    ORDER BY #{indicator} desc"""
    Rails.logger.debug { sql }
    return sql
  end
end
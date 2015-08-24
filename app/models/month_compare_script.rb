require 'date'
require 'hengdian'

#对比当年和前一前一年12月份的数据比较
class MonthCompareScript
  include Hengdian::Contants
  include Hengdian
  include TSColumns
  include DBUtils
  include LineSytle

  def get_data(years, use_room_type, indicator, order_type)
    result = []
    years.each_with_index do |year|
      result_sets = execute_query(get_sql(indicator, use_room_type, order_type, year))
      result_sets = NetworkOrderReportHelper.insert_defult_values_if_not_exists(result_sets,
                                                                  'month',
                                                                  indicator,
                                                                  1,
                                                                  12) {|x, y| x == y}
      result << {label: year,
                 data: result_sets.map { |x| x[indicator].to_i }}
    end
    return {
        labels: (1..12).map { |x| "#{x}月" },
        datasets: convert_to_report_format(result)
    }
  end

  private
  def get_sql(indicator, use_room_type, order_type,  year)
    date = DateTime.new(year, 1, 1)
    field = ''
    order_type_where_clause = ''
    case indicator
      when INDICATOR_ORDER_COUNT then
        field = 'COUNT(*)'
      when INDICATOR_PEOPLE_COUNT then
        field = 'SUM(b.DSjNumber)'
      when INDICATOR_TOTAL_MONEY then
        field = 'SUM(b.DSjAmount)'
    end
    Rails.logger.debug { "order_type = #{order_type}" }
    case order_type
      when 'all' then
        order_type_where_clause = ''
      when 'ticket' then
        order_type_where_clause = """AND NOT EXISTS (SELECT SellID FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                                     WHERE a.SellID = b.SellID AND b.CurID = 'N1')"""
      when 'hotel' then
        order_type_where_clause = """AND EXISTS (SELECT SellID FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                                                          WHERE a.SellID = b.SellID AND b.CurID = 'N1')
                                     AND (SELECT COUNT(*) FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                                          WHERE a.SellID = b.SellID AND AllowJdFlag = 0 AND CurID != '05') = 1"""
       when 'package' then
        order_type_where_clause = """AND EXISTS (SELECT SellID FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                                                WHERE a.SellID = b.SellID AND b.CurID = 'N1')
                                     AND (SELECT COUNT(*) FROM #{ticket_db_prefix(date)}.v_tbdTravelOkPro b
                                         WHERE a.SellID = b.SellID AND AllowJdFlag = 0) > 1"""
    end


    sql =   <<-SQL
            SELECT MONTH(DComeDate) as month, SUM(#{indicator}) as #{indicator} FROM (
                      SELECT DComeDate, #{field} as #{indicator} FROM #{ticket_db_prefix(date)}.v_tbdTravelOK a inner join
                            #{ticket_db_prefix(date)}.v_tbdTravelOkOther b on a.SellID = b.SellID
                            WHERE Flag in (1)
                                  AND EXISTS(SELECT b.DName FROM #{ticket_db_prefix(date)}.tbdGroupType b
                                                     WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                                                           AND DGroupRoomType = '#{use_room_type}')
                                  #{order_type_where_clause}
                                  AND DComeDate between '#{year}-1-1' and '#{year}-12-31'
                            GROUP BY DComeDate) as a
              Group by MONTH(DComeDate)
              ORDER BY month
            SQL

    Rails.logger.debug { sql }
    return sql
  end
end
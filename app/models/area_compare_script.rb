require 'date'

class AreaCompareScript

  include DBUtils
  include PieStyle

  def get_data(year, area_type, indicator, is_real_sell_info = false, topN = 9)
    # 处理参数
    area_Type_field = 'province'
    if area_type == 'city'
      area_Type_field = 'city'
    end

    # 组装sql语句, 查询数据库
    sql = get_sql(year.to_i, area_Type_field, indicator, is_real_sell_info)
    rows = execute_query(sql)

    return deal_result_set(rows, area_Type_field, topN, indicator)
  end

  def get_sql(year, area_type_field, indicator, is_real_sell_info = false)
    date = DateTime.new(year, 1, 1)
    if is_real_sell_info
      sql = """SELECT #{area_type_field}, COUNT(*) as order_count, SUM(DDjNumber) as people_count, cast(SUM(DAmount) as int) as total_money
               FROM (SELECT a.Sellid, DTel, c.DSjNumber as DDjNumber, (c.DSjAmount - c.DSjYhAmount) as DAmount,
                           (SELECT #{area_type_field} FROM report.dbo.t_phonenumber where phonenumber = SUBSTRING(DTel,0,8)) as #{area_type_field}
                     FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a inner join #{ticket_db_prefix(date)}.v_tbdTravelOkCustomer b on a.SellID = b.SellID
                     inner join #{ticket_db_prefix(date)}.v_tbdTravelOkOther c on a.SellID = c.SellID
                     WHERE a.Flag = 1 and exists(select * from #{ticket_db_prefix(date)}.tbdGroupType b where a.DGroupType = b.DName
                                                  and a.DGroupTypeAssort = b.sType and DGroupRoomType = '网络用房')
                          and DComeDate >= '#{year}-1-1' and DComeDate <= '#{year}-12-31') as a
               GROUP BY #{area_type_field}
               order by #{indicator} desc"""
    else
      sql = """SELECT #{area_type_field}, COUNT(*) as order_count, SUM(DDjNumber) as people_count, cast(SUM(DAmount) as int) as total_money
               FROM (SELECT a.Sellid, DTel, a.DDjNumber, a.DAmount,
                            (SELECT #{area_type_field} FROM report.dbo.t_phonenumber where phonenumber = SUBSTRING(DTel,0,8)) as #{area_type_field}
                     FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a inner join #{ticket_db_prefix(date)}.v_tbdTravelOkCustomer b on a.SellID = b.SellID
                     WHERE a. Flag = 1 and exists(select * from #{ticket_db_prefix(date)}.tbdGroupType b
                                                  where a.DGroupType = b.DName and a.DGroupTypeAssort = b.sType
                                                        and DGroupRoomType = '网络用房')
                           and DComeDate >= '#{year}-1-1' and DComeDate <= '#{year}-12-31') as a
            GROUP BY #{area_type_field}
            order by #{indicator} desc"""
    end
    Rails.logger.debug { sql }
    return sql
  end
end





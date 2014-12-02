class AreaCompareScript

  include DBUtils
  include PieStyle

  def get_data(year, area_type, indicator, is_real_sell_info = false, topN = 9)
    # 处理参数
    field_name = 'province'
    database = "#{ticket_server}.iccard14"
    if area_type == 'city'
      field_name = 'city'
    end

    if year == '2013'
      database = "#{ticket_server}.iccard13"
    elsif year == '2012'
      database = "#{ticket_server}.iccard12"
    end

    # 组装sql语句, 查询数据库
    sql = get_sql(year, field_name, database, indicator, is_real_sell_info)
    rows = execute_array(sql)

    return deal_result_set(rows, field_name, topN, indicator)
  end

  def get_sql(year, field_name, database, indicator, is_real_sell_info = false)
    if is_real_sell_info
      sql = """SELECT #{field_name}, COUNT(*) as order_count, SUM(DDjNumber) as people_count, cast(SUM(DAmount) as int) as total_money
               FROM (SELECT a.Sellid, DTel, c.DSjNumber as DDjNumber, (c.DSjAmount - c.DSjYhAmount) as DAmount,
                           (SELECT #{field_name} FROM report.dbo.t_phonenumber where phonenumber = SUBSTRING(DTel,0,8)) as #{field_name}
                     FROM #{database}.dbo.v_tbdTravelOk a inner join #{database}.dbo.v_tbdTravelOkCustomer b on a.SellID = b.SellID
                     inner join #{database}.dbo.v_tbdTravelOkOther c on a.SellID = c.SellID
                     WHERE a.Flag = 1 and exists(select * from #{database}.dbo.tbdGroupType b where a.DGroupType = b.DName
                                                  and a.DGroupTypeAssort = b.sType and DGroupRoomType = '网络用房')
                          and DComeDate >= '#{year}-1-1' and DComeDate <= '#{year}-12-31') as a
               GROUP BY #{field_name}
               order by #{indicator} desc"""
    else
      sql = """SELECT #{field_name}, COUNT(*) as order_count, SUM(DDjNumber) as people_count, cast(SUM(DAmount) as int) as total_money
               FROM (SELECT a.Sellid, DTel, a.DDjNumber, a.DAmount,
                            (SELECT #{field_name} FROM report.dbo.t_phonenumber where phonenumber = SUBSTRING(DTel,0,8)) as #{field_name}
                     FROM #{database}.dbo.v_tbdTravelOk a inner join #{database}.dbo.v_tbdTravelOkCustomer b on a.SellID = b.SellID
                     WHERE a. Flag = 1 and exists(select * from #{database}.dbo.tbdGroupType b
                                                  where a.DGroupType = b.DName and a.DGroupTypeAssort = b.sType
                                                        and DGroupRoomType = '网络用房')
                           and DComeDate >= '#{year}-1-1' and DComeDate <= '#{year}-12-31') as a
            GROUP BY #{field_name}
            order by #{indicator} desc"""
    end
    Rails.logger.debug sql
    return sql
  end
end





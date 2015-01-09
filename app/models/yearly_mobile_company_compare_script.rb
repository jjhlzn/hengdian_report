require 'date'
require 'hengdian'

class YearlyMobileCompanyCompareScript
  include DBUtils
  include PieStyle

  def get_data(year, indicator, topN)
    # 组装sql语句, 查询数据库
    sql = get_sql(year, indicator)
    rows = execute_query(sql)

    return deal_result_set(rows, 'corp', topN, indicator)
  end

  def get_sql(year, indicator)
    date = DateTime.new(year, 1, 1)
    sql = """SELECT corp, COUNT(*) as order_count, SUM(DDjNumber) as people_count, cast(SUM(DAmount) as int) as total_money
             FROM (SELECT a.Sellid, DTel, c.DSjNumber as DDjNumber, (c.DSjAmount - c.DSjYhAmount) as DAmount,
                         (SELECT corp FROM report.dbo.t_phonenumber where phonenumber = SUBSTRING(DTel,0,8)) as corp
                   FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a inner join #{ticket_db_prefix(date)}.v_tbdTravelOkCustomer b on a.SellID = b.SellID
                   inner join #{ticket_db_prefix(date)}.v_tbdTravelOkOther c on a.SellID = c.SellID
                   WHERE a.Flag = 1 and exists(select * from #{ticket_db_prefix(date)}.tbdGroupType b where a.DGroupType = b.DName
                                                and a.DGroupTypeAssort = b.sType and DGroupRoomType = '网络用房')
                        and DComeDate >= '#{year}-1-1' and DComeDate <= '#{year}-12-31') as a
             GROUP BY corp
             order by #{indicator} desc"""
    Rails.logger.debug { sql }
    return sql
  end
end
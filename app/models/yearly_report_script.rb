require 'date'
require 'hengdian'

class YearlyReportScript
  def get_all_month_data(year)

  end

  private
  def get_all_month_data_sql(date)
    sql = <<-SQL
              SELECT MONTH(DComeDate) as month, SUM(DDjNumber) AS people_count, SUM(DAmount) AS total_money, COUNT(*) AS order_count
              FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a
              WHERE DComeDate BETWEEN '#{date.year}-1-1' AND '#{date.year}-12-31'
                  AND Flag = 1
                  AND EXISTS(SELECT * FROM #{ticket_db_prefix(date)}.tbdGroupType b
                       WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                           AND DGroupRoomType = '网络用房')
              GROUP BY MONTH(DComeDate)
              ORDER BY month
          SQL
    Rails.logger.debug { sql }
    return sql
  end
end
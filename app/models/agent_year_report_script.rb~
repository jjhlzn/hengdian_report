require 'date'
require 'hengdian'

class AgentYearReportScript
  include DBUtils
  include Hengdian
  include Hengdian::Contants
  include PieStyle

  def get_data(year, indicator=INDICATOR_PEOPLE_COUNT, topn = 10)
    result_sets = execute_query(get_sql(DateTime.new(year, 1, 1), indicator))
    return deal_result_set(result_sets, 'AgentName', topn + 1, indicator)
  end

  private
  def get_sql(date, indicator)
    Rails.logger.debug { "date = #{date}" }
    sql = """SELECT DTravelNo, (SELECT c.DName FROM #{ticket_db_prefix(date)}.tbdTravelAgencyInfo c WHERE c.DTravelNo = a.DTravelNo) as AgentName,
                    SUM(DDjNumber) AS people_count, SUM(DAmount) AS total_money, COUNT(*) AS order_count
            FROM #{ticket_db_prefix(date)}.v_tbdTravelOk a
            WHERE DComeDate BETWEEN '#{date.year}-1-1' AND '#{date.year}-12-31'
                AND Flag = 1
                AND EXISTS(SELECT * FROM #{ticket_db_prefix(date)}.tbdGroupType b
                     WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                         AND DGroupRoomType = '网络用房')
                GROUP BY DTravelNo
                ORDER BY #{indicator} desc"""
    Rails.logger.debug { sql }
    return sql
  end
end


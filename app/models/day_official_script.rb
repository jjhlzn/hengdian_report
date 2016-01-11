require 'hengdian'

class DayOfficialScript
  include Hengdian::Contants
  include TSColumns
  include DBUtils
  include LineSytle

  #返回包含在years中各年的日期从[from_date, to_date]的订单汇总信息
  #注意: from_date和to_date必须在同一年,否则报错
  def get_data(indicator, datetype, agents, from_date, to_date)
    raise "from_date必须和to_date在同一年份" unless from_date.year == to_date.year
    result = []
    agents.each_with_index do |agent, index|
      from_date = DateTime.new(from_date.year, from_date.month, from_date.day)
      to_date = DateTime.new(from_date.year, to_date.month, to_date.day)
      result_sets = execute_query(get_sql(indicator, datetype, agent[:agentNo], from_date, to_date))
      result_sets = NetworkOrderReportHelper.insert_defult_values_if_not_exists(result_sets,
                                                                                'date',
                                                                                indicator,
                                                                                from_date,
                                                                                to_date) {|x, y| x.strftime('%F') == y.strftime('%F')}
      result << {label: agent[:agentName],
                 data: result_sets.map { |x| x[indicator].to_i }}
    end
    return {
        labels: (from_date..to_date).map { |x| x.strftime('%m-%d') },
        datasets: convert_to_report_format(result)
    }
  end

  def get_data_official_website(indicator, datetype, agent, years, from_date, to_date)
    raise "from_date必须和to_date在同一年份" unless from_date.year == to_date.year
    result = []
    years.each_with_index do |year, index|
      from_date = DateTime.new(year, from_date.month, from_date.day)
      to_date = DateTime.new(year, to_date.month, to_date.day)
      result_sets = execute_query(get_sql(indicator, datetype, agent[:agentNo], from_date, to_date))
      result_sets = NetworkOrderReportHelper.insert_defult_values_if_not_exists(result_sets,
                                                                                'date',
                                                                                indicator,
                                                                                from_date,
                                                                                to_date) {|x, y| x.strftime('%F') == y.strftime('%F')}
      result << {label: year,
                 data: result_sets.map { |x| x[indicator].to_i }}
    end
    return {
        labels: (from_date..to_date).map { |x| x.strftime('%m-%d') },
        datasets: convert_to_report_format(result)
    }
  end


  private
  def get_sql(indicator, datetype, agent, from_date, to_date)
    year = from_date.year

    indicator_field = ''
    datetype_field = ''

    case indicator
      when INDICATOR_ORDER_COUNT then
        indicator_field = 'COUNT(*)'
      when INDICATOR_PEOPLE_COUNT then
        indicator_field = 'SUM(a.DDjNumber)'
      when INDICATOR_TOTAL_MONEY then
        indicator_field = 'SUM(a.DAmount)'
    end

    case datetype
      when DATETYPE_BY_COMEDATE then
        datetype_field = 'DComeDate'
      when DATETYPE_BY_ORDERDATE then
        datetype_field = 'DDate'
    end

    flags = '0, 1'

    ticket_db_name = get_ticket_database(DateTime.new(year.to_i, 1, 1))
    sql = "" "SELECT #{datetype_field} as date, #{indicator_field} as #{indicator} FROM #{ticket_server}.#{ticket_db_name}.dbo.v_tbdTravelOK a inner join
              #{ticket_server}.#{ticket_db_name}.dbo.v_tbdTravelOkOther b on a.SellID = b.SellID
              WHERE Flag in (#{flags})
                    AND EXISTS(SELECT b.DName FROM #{ticket_server}.#{ticket_db_name}.dbo.tbdGroupType b
                                       WHERE a.DGroupType = b.DName AND a.DGroupTypeAssort = b.sType
                                             AND DGroupRoomType = '网络用房' and DTravelNo = '#{agent}' )
                    AND #{datetype_field} between '#{from_date.strftime('%F')}' and '#{to_date.strftime('%F')}'
              GROUP BY #{datetype_field}
              ORDER BY #{datetype_field}"""

    Rails.logger.debug { sql }
    return sql
  end
end
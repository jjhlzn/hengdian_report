require 'date'
require 'hengdian'

#对比网络,团队,上门散客各个指标对比
class SellTypeCompareScript
  include Hengdian::Contants
  include Hengdian
  include TSColumns
  include DBUtils
  include PieStyle

  #获取年份级别的对比
  def get_yearly_compare_data(year, indicator)
    monthScript = MonthCompareScript.new

    #获取网络散客的数据
    network_month_data = monthScript.get_data([year], '网络用房', indicator, 'all')

    network_data = network_month_data[:datasets][0][:data].reduce { |x,y| x + y}
    #获取团队的数据
    group_month_data = monthScript.get_data([year], '常规用房', indicator, 'all')
    group_data = group_month_data[:datasets][0][:data].reduce { |x,y| x + y}
    #获取上面散客的数据
    visitor_data = get_visitor_data(year, indicator)

    deal_result_set([{type: '网络散客', indicator => network_data},
                     {type: '团队', indicator => group_data},
                     {type: '上门散客', indicator => visitor_data} ],
                     :type,
                     3,
                     indicator)
  end

  private
  def get_visitor_data(year, indicator)
    rows = execute_query(get_visitor_data_sql(year, indicator,))
    Rails.logger.debug {rows}
    rows[0][indicator]
  end

  def get_visitor_data_sql(year, indicator)
    indicator_field = ''
    case indicator
      when INDICATOR_ORDER_COUNT then
        indicator_field = 'COUNT(*)'
      when INDICATOR_PEOPLE_COUNT then
        indicator_field = 'SUM(DPeople)'
      when INDICATOR_TOTAL_MONEY then
        indicator_field = 'SUM(DPayMoney)'
    end
    sql = <<-SQL
       SELECT #{indicator_field} as #{indicator}  FROM #{ticket_db_prefix(year)}.v_tbdSp
       WHERE DDate >= '#{year}-01-01' AND DDate <= '#{year}-12-31' AND sType in ('普通售票', '自动售票')
    SQL

    Rails.logger.debug {sql}
    sql
  end

end
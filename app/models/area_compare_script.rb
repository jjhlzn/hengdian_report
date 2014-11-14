class AreaCompareScript
  def initialize
    @colors = ['#659AC9', '#A0BFBE', '#ADC896', '#B58371', '#DA917A', \
               '#BE98B7', '#8B814C', '#CD69C9', '#CDC673', '#EEE8CD', \
               '#CD919E', '#C1CDC1', '#8B8878', '#7F7F7F', '#607B8B', \
               '#4682B4', '#C67171', '#C0FF3E', '#C5C1AA', '#B9D3EE', \
               '#8C8C8C']
  end

  def get_data(year, area_type, indicator, is_real_sell_info = false, topN = 9)
    # 处理参数
    field_name = 'province'
    database = "#{DBUtils.ticket_server}.iccard14"
    if area_type == 'city'
      field_name = 'city'
    end

    if year == '2013'
      database = "#{DBUtils.ticket_server}.iccard13"
    elsif year == '2012'
      database = "#{DBUtils.ticket_server}.iccard12"
    end

    # 组装sql语句, 查询数据库
    sql = get_sql(year, field_name, database, indicator, is_real_sell_info)
    rows = DBUtils.execute_array(sql)

    # 处理数据库结果
    total = (rows.map { |x| x[indicator] }).reduce(0, :+)

    rows.each_with_index do |row, rank|
      row['percent'] = format("%.2f", row[indicator] / total.to_f * 100) + '%'
      row['label'] = row[field_name]
      row['value'] = row[indicator]
      row['rank'] = rank + 1
      unless row['label']
          row['label'] = '未知'
      end
    end

    datasets = []
    other = {  field_name => '其他',
               'order_count' => 0,
               'people_count' => 0,
               'total_money' => 0,
               'color' => @colors[-1] }
    rows.each_with_index do |row, index|
      if index > topN - 1
          other['order_count'] += row['order_count']
          other['people_count'] += row['people_count']
          other['total_money'] += row['total_money']
      else
          row['color'] = @colors[index]
          datasets.append(row)
      end
    end
    datasets.append(other)
    Rails.logger.debug { "other = #{other}" }
    datasets = datasets.map { |x| { value:     x[indicator].to_i,
                                    color:     x['color'],
                                    highlight: x['color'],
                                    label:     x[field_name] ? x[field_name] : '未知'
                                  } }
    rows.append({percent: '100%', label: '总和', value: total, rank: ''})
    return [datasets, rows]
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





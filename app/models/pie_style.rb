module PieStyle
  @@colors = ['#659AC9', '#A0BFBE', '#ADC896', '#B58371', '#DA917A', \
               '#BE98B7', '#8B814C', '#CD69C9', '#CDC673', '#EEE8CD', \
               '#CD919E', '#C1CDC1', '#8B8878', '#7F7F7F', '#607B8B', \
               '#4682B4', '#C67171', '#C0FF3E', '#C5C1AA', '#B9D3EE', \
               '#8C8C8C']

  private
  def deal_result_set(rows, field_name, topN, indicator)
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
               'color' => @@colors[-1] }
    rows.each_with_index do |row, index|
      if index > topN - 1
        other['order_count'] += row['order_count']
        other['people_count'] += row['people_count']
        other['total_money'] += row['total_money']
      else
        row['color'] = @@colors[index]
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
end
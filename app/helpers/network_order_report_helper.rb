module NetworkOrderReportHelper
=begin
end
  def self.insert_defult_values_if_not_exists(array, key_name, value_name, from, to, default_value = 0)
    (from..to).each do |x|
      unless array.any? {|y| y[key_name].strftime('%F') == x.strftime('%F')}
        Rails.logger.debug { "x = " + x.inspect }
        array << { key_name => x,  value_name => default_value }
      end
    end
    Rails.logger.debug { "array: " + array.inspect }
    return array.sort_by { |x| x[key_name] }
  end
=end

  def self.insert_defult_values_if_not_exists(array, key_name, value_name, from, to, default_value = 0, &check_func)
    (from..to).each do |x|
      unless array.any? {|y| check_func.call(y[key_name], x)}
        Rails.logger.debug { "x = " + x.inspect }
        array << { key_name => x,  value_name => default_value }
      end
    end
    Rails.logger.debug { "array: " + array.inspect }
    return array.sort_by { |x| x[key_name] }
  end
end

module ApplicationHelper
  def make_success_json_resp(data)
    response_data = {}
    response_data['data'] = data
    response_data['status'] = 0
    response_data['message'] = 'success'
    return response_data
  end

  def handle_days(from_date, to_date)
    if from_date.year != to_date.year
      if to_date.year == 2015
        result = [DateTime.new(from_date.year, 12, 1), DateTime.new(from_date.year, 12, 31)]
      else
        result = [DateTime.new(to_date.year, 1, 1), to_date]
      end
    else
      result = [from_date, to_date]
    end
    Rails.logger.debug { "from = #{result[0]}, to = #{result[1]}"}
    return result
  end
end

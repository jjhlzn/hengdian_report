module ApplicationHelper
  def make_success_json_resp(data)
    response_data = {}
    response_data['data'] = data
    response_data['status'] = 0
    response_data['message'] = 'success'
    return response_data
  end
end

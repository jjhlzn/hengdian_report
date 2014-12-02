require 'date'
require 'hengdian'

class NetworkOrderReportController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants


  def latest_30days_report
    respond_to do |format|
      format.json do
        service = Latest30DaysReportScript.new
        years = [2014, 2013]
        from_date = DateTime.new(2014, 7, 1)
        to_date = DateTime.new(2014, 7, 30)
        result = service.get_data(INDICATOR_ORDER_COUNT, years, from_date, to_date)
        render json: make_success_json_resp(result)
      end
    end
  end



end

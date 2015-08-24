require 'date'
require 'hengdian'

class NetworkOrderReportController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants


  def latest_30days_report
    respond_to do |format|
      format.json do
        service = LatestReserveReportScript.new
        this_year = DateTime.now.year
        years = [this_year, this_year - 1, this_year - 2]
        dates = handle_days(DateTime.now.prev_month, DateTime.now)
        result = service.get_data(params[:indicator], DATETYPE_BY_COMEDATE, '网络用房', true, years, dates[0], dates[1])
        render json: make_success_json_resp(result)
      end
    end
  end
end

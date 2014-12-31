require 'date'
require 'hengdian'

class NetworkOrderReportController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants


  def latest_30days_report
    respond_to do |format|
      format.json do
        service = LatestReserveReportScript.new
        years = [2014, 2013]
        dates = handle_days(DateTime.now.prev_month, DateTime.now)
        result = service.get_data(params[:indicator], DATETYPE_BY_COMEDATE, true, years, dates[0], dates[1])
        render json: make_success_json_resp(result)
      end
    end
  end
end

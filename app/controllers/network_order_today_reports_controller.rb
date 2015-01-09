require 'date'
require 'hengdian'

class NetworkOrderTodayReportsController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants

  def index
    respond_to do |format|
      format.html
      format.json do
        service = DayReportScript.new
        date = DateTime.now
        result = service.get_order_stat date, params[:datetype], params[:indicator]
        render json: make_success_json_resp(result)
      end
    end
  end

  #以前和未来10天的预订情况
  def reserve
    respond_to do |format|
      format.json do
        service = LatestReserveReportScript.new
        this_year = DateTime.now.year
        years = [this_year, this_year - 1, this_year - 2]
        dates = handle_days(DateTime.now.days_ago(10), DateTime.now.days_since(10))
        result = service.get_data(params[:indicator], params[:datetype], false, years, dates[0], dates[1])
        render json: make_success_json_resp(result)
      end
    end
  end


end

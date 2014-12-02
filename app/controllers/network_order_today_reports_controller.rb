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
        date = DateTime.now.prev_month.prev_month.prev_month.prev_month
        result = service.get_order_stat date, params[:indicator]
        render json: make_success_json_resp(result)
      end
    end
  end
end

require 'hengdian'
require 'date'

class NetworkOrderMonthReportsController < ApplicationController
  include ApplicationHelper

  def index
    respond_to do |format|
      format.html
      format.json do
        service = MonthCompareScript.new
        cur_year = DateTime.now.year
        result = service.get_data([cur_year, cur_year-1], params[:indicator])
        render json: make_success_json_resp(result)
      end
    end
  end
  
end

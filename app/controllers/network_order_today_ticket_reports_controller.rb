require 'date'
require 'hengdian'

class NetworkOrderTodayTicketReportsController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants

  def index
    respond_to do |format|
      format.html
      format.json do
        service = TodayTicketReportScript.new
        date = DateTime.new(2014, 7, 1)
        result = service.get_topn_production(date, INDICATOR_PEOPLE_COUNT)
        render json: make_success_json_resp(result)
      end
    end
  end
end

require 'date'
require 'hengdian'

class NetworkOrderYearlyReportsController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants

  def index
    respond_to do |format|
      format.html
      format.json do
        service = YearlyProductionCompareScript.new
        result = service.get_order_stat(params[:year].to_i, params[:indicator])
        render json: make_success_json_resp(result)
      end
    end
  end
end

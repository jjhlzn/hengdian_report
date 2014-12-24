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

  def mobile_company_cmp
    respond_to do |format|
      format.json do
        service = YearlyMobileCompanyCompareScript.new
        result_set = service.get_data(params[:year].to_i, params[:indicator], 10)
        return_data = {'datasets' => result_set[0],
                       'datasets_src' => result_set[1]}
        render json: make_success_json_resp(return_data)
      end
    end
  end
end

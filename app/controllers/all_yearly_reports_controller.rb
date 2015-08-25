require 'date'
require 'hengdian'

class AllYearlyReportsController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants

  def index

  end

  def get_selltype_compare
    respond_to do |format|
      format.json do
        service = SellTypeCompareScript.new
        result = service.get_yearly_compare_data params[:year].to_i, params[:indicator]
        return_data = {'datasets' => result[0],
                       'datasets_src' => result[1]}
        render json: make_success_json_resp(return_data)
      end
    end
  end
end

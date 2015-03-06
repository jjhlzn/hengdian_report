require 'date'
require 'hengdian'

class NetworkOrderAreaComparesController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants
  def index
    respond_to do |format|
      format.html
      format.json do
        #获取参数year, indicator, is_real_sell_info, topn
        #查询数据库获取数据
        service = AreaCompareScript.new
        result_set= service.get_data(params[:year],
                                    params[:from_date],
                                    params[:end_date],
                                    params[:type],
                                    params[:indicator],
                                    true,
                                    params[:topn].to_i)

        return_data = {'datasets' => result_set[0],
                       'datasets_src' => result_set[1]}


        #返回结果
        render json: make_success_json_resp(return_data)
      end
    end
  end
end

require 'date'

class NetworkOrderReportController < ApplicationController
  include ApplicationHelper
  def area_compare
    respond_to do |format|
      format.html
      format.json do
        #获取参数year, indicator, is_real_sell_info, topn
        #查询数据库获取数据
        service = AreaCompareScript.new
        province_datasets= service.get_data(params[:year],
                                            'province',
                                            params[:indicator],
                                            params[:is_real_sell_info] == '1',
                                            params[:topn].to_i)
        city_datasets = service.get_data(params[:year],
                                         'city',
                                         params[:indicator],
                                         params[:is_real_sell_info] == '1',
                                         params[:topn].to_i)
        return_data = {'datasets' => province_datasets[0],
                   'datasets_src' => province_datasets[1],
                   'datasets1' => city_datasets[0],
                   'datasets1_src' => city_datasets[1],
                   'params' => params}

        #返回结果
        render json: make_success_json_resp(return_data)
      end
    end
  end

  def today_report
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

  def test
  end


end

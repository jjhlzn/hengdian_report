class NetworkOrderReportController < ApplicationController
  def area_compare
    respond_to do |format|
      format.html
      format.json do
        #获取参数

        #查询数据库获取数据
        service = AreaCompareScript.new
        data = service.get_data('2014', 'province', 'people_count')

        #返回结果
        render json: ApplicationHelper.make_success_json_resp(data)
      end
    end
  end

  def test
  end



end

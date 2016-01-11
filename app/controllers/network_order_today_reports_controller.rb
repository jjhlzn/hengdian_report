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
        result = service.get_data(params[:indicator], params[:datetype], '网络用房', false, years, dates[0], dates[1])
        render json: make_success_json_resp(result)
      end
    end
  end

  #官网前后10的预订情况
  def official
    respond_to do |format|
      format.json do
        service = DayOfficialScript.new
        agents = [{agentName: '横店影视城网络运营中心', agentNo:'330783018100'},
                  {agentName: '淘宝旗舰店', agentNo: '330783021600'}]
        dates = handle_days(DateTime.now.days_ago(10), DateTime.now.days_since(10))
        result = service.get_data(params[:indicator], params[:datetype], agents, dates[0], dates[1])
        render json: make_success_json_resp(result)
      end
    end
  end

  def official_website
    respond_to do |format|
      format.json do
        service = DayOfficialScript.new
        agent = {agentName: '横店影视城网络运营中心', agentNo:'330783018100'}
        dates = handle_days(DateTime.now.days_ago(10), DateTime.now.days_since(10))
        years = [DateTime.now.year, DateTime.now.year - 1]
        result = service.get_data_official_website(params[:indicator], params[:datetype], agent, years, dates[0], dates[1])
        render json: make_success_json_resp(result)
      end
    end
  end

  def official_taobao
    respond_to do |format|
      format.json do
        service = DayOfficialScript.new
        agent = {agentName: '淘宝旗舰店', agentNo: '330783021600'}
        dates = handle_days(DateTime.now.days_ago(10), DateTime.now.days_since(10))
        years = [DateTime.now.year, DateTime.now.year - 1]
        result = service.get_data_official_website(params[:indicator], params[:datetype], agent, years, dates[0], dates[1])
        render json: make_success_json_resp(result)
      end
    end
  end


end

require 'hengdian'

class NetworkOrderYearlyAgentReportsController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants

  def index
    respond_to do |format|
      format.html
      format.json do
        service = AgentYearReportScript.new
        render json: make_success_json_resp({'datasets' => service.get_data(params[:year].to_i, params[:indicator])[0]})
      end
    end

  end
end

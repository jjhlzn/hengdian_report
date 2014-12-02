require 'hengdian'

class NetworkOrderYearlyAgentReportsController < ApplicationController
  include ApplicationHelper
  include Hengdian::Contants

  def index
    respond_to do |format|
      format.json do
        service = AgentYearReportScript.new
        render json: service.get_data(2014)
      end
    end

  end
end

class TimerTaskController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        TimerTask.new.exec()
        render json: {status: 1}
      end
    end
  end

  def init
    respond_to do |format|
      format.json do
        TimerTask.new().init()
        render json: {status: 1}
      end
    end
  end
end

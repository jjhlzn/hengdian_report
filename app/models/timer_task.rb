

class TimerTask
  def exec
    #找到当前目录下所有的任务,然后逐一执行
    AnalyseOrderTypeTask.new().exec()
    AnalyseOrderAgentTypeTask.new().exec()
  end

  def init
    AnalyseOrderTypeTask.new().init()
    AnalyseOrderAgentTypeTask.new().init()
  end
end
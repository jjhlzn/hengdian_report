module BarStyle
  @@colors = [
      {
          fillColor: "rgba(151,187,205,0.5)",
          strokeColor: "rgba(151,187,205,0.8)",
          highlightFill: "rgba(151,187,205,0.75)",
          highlightStroke: "rgba(151,187,205,1)",
      }
  ]


  def convert_to_report_format(datasets)
    result = []
    datasets.each_with_index { |item, index|
      result << item.merge(@@colors[index])
    }
    return result
  end
end
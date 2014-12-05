module LineSytle
  @@colors = [
      {
          fillColor: "rgba(151,187,205,0.2)",
          strokeColor: "rgba(151,187,205,1)",
          pointColor: "rgba(151,187,205,1)",
          pointStrokeColor: "#fff",
          pointHighlightFill: "#fff",
          pointHighlightStroke: "rgba(151,187,205,1)",
      },
      {
          fillColor: "rgba(220,220,220,0.2)",
          strokeColor: "rgba(220,220,220,1)",
          pointColor: "rgba(220,220,220,1)",
          pointStrokeColor: "#fff",
          pointHighlightFill: "#fff",
          pointHighlightStroke: "rgba(220,220,220,1)",
      },
  ]

  def convert_to_report_format(datasets)
    result = []
    datasets.each_with_index { |item, index|
      result << item.merge(@@colors[index])
    }
    return result
  end
end
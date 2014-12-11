/**
 * Created by jjh on 12/6/14.
 */
var BarReportChart = function (id, name, height, width, url, other_response_deal_function) {
    this.default_response_deal_function = function (respJSON, canvas_id, graph_name) {
        this.draw_report('Bar', respJSON.data,
            {responsive: true});
    };

    //this.initialize(id, name, height, width, url, other_response_deal_function);
    this.initialize.apply(this, arguments);
}

BarReportChart.inherits(ReportChart)
/**
 * Created by jjh on 12/5/14.
 */
var LineReportChart = function (id, name, height, width, url, other_response_deal_function) {
    this.default_response_deal_function = function (respJSON, canvas_id, graph_name) {
        this.draw_report('Line', respJSON.data,
                        {
                            responsive: true,
                            pointHitDetectionRadius: 1,
                            datasetFill: false
                        });
    };

    //this.initialize(id, name, height, width, url, other_response_deal_function);
    this.initialize.apply(this, arguments);
}

LineReportChart.inherits(ReportChart)
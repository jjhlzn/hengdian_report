/**
 * Created by jjh on 12/3/14.
 */
PieReportChart.inherits(ReportChart)

function PieReportChart(id, name, height, width, url, other_response_deal_function) {

    this.default_response_deal_function = function (respJSON, canvas_id, graph_name ) {
        //this.params = respJSON.data.params || this.params;
        var options = {  responsive: true,
            pointHitDetectionRadius: 1,
            datasetFill: false,
            pointDot: respJSON.data.pointDot };
        this.draw_report('Pie', respJSON.data.datasets, options);
    };

    this.initialize(id, name, height, width, url, other_response_deal_function);
}








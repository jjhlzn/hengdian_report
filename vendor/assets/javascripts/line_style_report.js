/**
 * Created by jjh on 12/5/14.
 */
var LineReportChart = function (canvas_id, graph_name, url, other_response_deal_function) {
    this.draw_report = function (canvas_id, datasets, graph_name, options) {
        var ctx = document.getElementById(canvas_id).getContext("2d");
        window[graph_name] = new Chart(ctx).Line(datasets, options);

        // Include a html legend template after the module doughnut itself
        var legendHolder = $("<div id='" + canvas_id + "_legend'>")[0];
        legendHolder.innerHTML = window[graph_name].generateLegend();
        document.getElementById(canvas_id).parentNode.parentNode.appendChild(legendHolder.firstChild);
    };

    this.default_response_deal_function = function (respJSON, canvas_id, graph_name) {
        this.params = respJSON.data.params;
        this.draw_report(canvas_id, respJSON.data, graph_name,
                        {
                            responsive: true,
                            pointHitDetectionRadius: 1,
                            datasetFill: false
                        });
    };

    this.initialize(canvas_id, graph_name, url, other_response_deal_function);
}

LineReportChart.inherits(ReportChart)
/**
 * Created by jjh on 12/3/14.
 */
PieReportChart.inherits(ReportChart)

function PieReportChart(id, name, height, width, graph_name, url, other_response_deal_function) {

    this.draw_report = function (canvas_id, datasets, graph_name, options){
        var ctx = document.getElementById(canvas_id).getContext("2d");
        window[graph_name] = new Chart(ctx).Pie(datasets, options);

        // Include a html legend template after the module doughnut itself
        var legendHolder = $("<div id='" + id + "_legend'>")[0];
        legendHolder.innerHTML = window[graph_name].generateLegend();
        document.getElementById(canvas_id).parentNode.parentNode.appendChild(legendHolder.firstChild);
        console.log('after call draw_pie()')
    };

    this.default_response_deal_function = function (respJSON, canvas_id, graph_name) {
        this.params = respJSON.data.params;

        var datasets = respJSON.data.datasets;
        var options = {  responsive: true,
            pointHitDetectionRadius: 1,
            datasetFill: false,
            pointDot: respJSON.data.pointDot };
        this.draw_report(canvas_id, datasets, graph_name, options);
    };

    this.initialize(id, name, height, width, graph_name, url, other_response_deal_function);
}








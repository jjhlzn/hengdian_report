/**
 * Created by jjh on 12/3/14.
 */
PieRequest.prototype = new ReportRequest();
function PieRequest(canvas_id, graph_name, url, other_response_deal_function) {
    console.log('call PieRequest()')
    console.log("canvas_id = "+canvas_id);
    this.draw_report = function (canvas_id, datasets, graph_name, options){
        console.log("draw_report: canvas_id = "+canvas_id);
        var ctx = document.getElementById(canvas_id).getContext("2d");
        window[graph_name] = new Chart(ctx).Pie(datasets, options);
        // Include a html legend template after the module doughnut itself
        var legendHolder = $("<div id='" + canvas_id + "_legend'>")[0];
        legendHolder.innerHTML = window[graph_name].generateLegend();
        document.getElementById(canvas_id).parentNode.parentNode.appendChild(legendHolder.firstChild);
        console.log('after call draw_pie()')
    };

    this.default_response_deal_function = function (respJSON, canvas_id, graph_name) {
        this.params = respJSON.data.params;
        console.log("params = " + this.params);
        var datasets = respJSON.data.datasets;
        var options = {  responsive: true,
            pointHitDetectionRadius: 1,
            datasetFill: false,
            pointDot: respJSON.data.pointDot };
        console.log('before draw pie');
        console.log("canvas_id = "+canvas_id);
        this.draw_report(canvas_id, datasets, graph_name, options);
    };

    this.params = {};
    this.graph_name = graph_name;
    this.url = url;
    this.canvas_id = canvas_id;
    this.other_response_deal_function  = other_response_deal_function;
}






var params = {};

var product_diff_pie_req = null;
$(document).ready( function() {
    product_diff_pie_req = new PieRequest('canvas', 'pie', '/network_order_today_reports.json')
    product_diff_pie_req.params['indicator'] = 'people_count';
    product_diff_pie_req.send();
    send_today_report_req(product_diff_pie_req.params)
});

function send_today_report_req(params) {
    send_data_request('/network_order_report/latest_30days_report.json',
        params,
        deal_resonse_json2);
}

function deal_resonse_json2(respJSON) {
    if (respJSON.status != 0) {
        alert('服务器返回错误（status = ' + respJSON.status
        + ", message = " + respJSON.message + ')');
        return;
    }
    draw_report2( respJSON.data,
        {responsive: true} );
}

function change_dataset(key, value, desc) {
    window.pie.destroy();
    params[key] = value;
    $('#lbl_' + key).html(desc);
    $("ul.pie-legend").remove();
    send_today_report_req(params);
}

function draw_report(respData, options) {
    //将respData转化为Chart.js识别的格式类型
    var data = convert_to_chartjs_pie(respData);
    draw_pie('canvas', data, 'pie',  options);
}

function draw_report2(respData, options) {
    //将respData转化为Chart.js识别的格式类型
    var data = convert_to_chartjs_line(respData);
    draw_line('canvas2', data, 'line',  options);
}

function convert_to_chartjs_line(data) {
    var labels = data['days'];
    //alert(labels);
    var datasets = data['values'];
    //alert(datasets);
    var result = [];
    for(var i = 0; i < datasets.length; i++) {
        var item = datasets[i];
        result.push({
            label: item['year'],
            fillColor:   "rgba(220,220,220,0.2)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor:  "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: item['data']
        })
    }
    return {
        labels: labels,
        datasets: result
    };
}

function draw_line(canvas_id, data, graph_name,  options) {
    var ctx = document.getElementById(canvas_id).getContext("2d");
    window[graph_name] = new Chart(ctx).Line(data, options);
}

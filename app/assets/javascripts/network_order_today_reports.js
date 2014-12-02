var params = {};
$(document).ready( function() {
    params['indicator'] = 'people_count'
    send_today_report_req(params)
});

function send_today_report_req(params) {
    send_data_request('network_order_today_reports.json',
        params,
        deal_resonse_json);
    send_data_request('/network_order_report/latest_30days_report.json',
        params,
        deal_resonse_json2);
}

function deal_resonse_json(respJSON) {
    if (respJSON.status != 0) {
        alert('服务器返回错误（status = ' + respJSON.status
        + ", message = " + respJSON.message + ')');
        return;
    }
    draw_report( respJSON.data,
        {responsive: true,
            pointHitDetectionRadius: 1,
            datasetFill: false,
            pointDot: respJSON.data} );
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

//将数据转化为chartjs识别的格式
function convert_to_chartjs_pie(data) {
    var result = [];
    for(var i = 0; i < data.length; i++) {
        var item = data[i];
        result.push({
            value: item.value,
            color: COLORS[i],
            highlight: COLORS[i],
            label: item.name
        });
    }
    return result;
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

function draw_pie(canvas_id, datasets, graph_name, options) {
    var ctx = document.getElementById(canvas_id).getContext("2d");
    window[graph_name] = new Chart(ctx).Pie(datasets, options);

    var legendHolder = $("<div id='" + canvas_id + "_legend'>")[0];
    legendHolder.innerHTML = window[graph_name].generateLegend();
    // Include a html legend template after the module doughnut itself

    document.getElementById(canvas_id).parentNode.parentNode
        .appendChild(legendHolder.firstChild);
}

function draw_line(canvas_id, data, graph_name,  options) {
    var ctx = document.getElementById(canvas_id).getContext("2d");
    window[graph_name] = new Chart(ctx).Line(data, options);
}

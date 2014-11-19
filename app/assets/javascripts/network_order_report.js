var datasets = {}
var datasets_src;
var datasets1 = {}
var datasets1_src;
var params = {};
window.onload = function () {
    params['indicator'] = 'people_count'
    send_today_report_req(params)
};

function send_today_report_req(params) {
    send_data_request('/network_order_report/today_report.json',
        params,
        deal_resonse_json);
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
    draw_graph('canvas', data, 'pie',  options);
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

function draw_graph(canvas_id, datasets, graph_name, table_id, options) {
    var ctx = document.getElementById(canvas_id).getContext("2d");
    window[graph_name] = new Chart(ctx).Pie(datasets, options);

    var legendHolder = $("<div id='" + canvas_id + "_legend'>")[0];
    legendHolder.innerHTML = window[graph_name].generateLegend();
    // Include a html legend template after the module doughnut itself

    document.getElementById(canvas_id).parentNode.parentNode
        .appendChild(legendHolder.firstChild);
}

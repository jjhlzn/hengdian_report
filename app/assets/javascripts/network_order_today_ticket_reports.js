var params = {};
$(document).ready( function() {
    params['indicator'] = 'people_count'
    send_today_ticket_report_req(params)
});

function send_today_ticket_report_req(params) {
    send_data_request('network_order_today_ticket_reports.json',
        params,
        deal_resonse_json);
}

function change_dataset(key, value, desc) {
    window.bar.destroy();
    params[key] = value;
    $('#lbl_' + key).html(desc);
    send_today_ticket_report_req(params);
}

function deal_resonse_json(respJSON) {
    if (respJSON.status != 0) {
        alert('服务器返回错误（status = ' + respJSON.status + ", message = " + respJSON.message + ')');
        return;
    }
    draw_report( respJSON.data,
                 {responsive: true,
                  pointHitDetectionRadius: 1,
                  datasetFill: false,
                  pointDot: respJSON.data} );
}

function draw_report(respData, options) {
    //将respData转化为Chart.js识别的格式类型
    var data = convert_to_chartjs_bar(respData);
    draw_bar('canvas', data, 'bar',  options);
}

//将数据转化为chartjs识别的格式
function convert_to_chartjs_bar(data) {
    var result = {
                   labels: data.names,
                   datasets: [
                       {
                           label: "景点",
                           fillColor: "rgba(151,187,205,0.5)",
                           strokeColor: "rgba(151,187,205,0.8)",
                           highlightFill: "rgba(151,187,205,0.75)",
                           highlightStroke: "rgba(151,187,205,1)",
                           data: data.values
                       }
                   ]
    };
    return result;
}

function draw_bar(canvas_id, datasets, graph_name, options) {
    var ctx = document.getElementById(canvas_id).getContext("2d");
    window[graph_name] = new Chart(ctx).Bar(datasets, options);
}

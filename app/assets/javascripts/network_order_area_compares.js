var datasets = {}
var datasets_src;
var datasets1 = {}
var datasets1_src;
var params = {};
window.onload = function () {
    params['year'] = '2014'
    params['indicator'] = 'people_count'
    params['is_real_sell_info'] = '0'
    params['topn'] = '15'
    send_data_request(params)
};

function send_data_request(params) {
    $.ajax({
        type: "GET",
        url: "network_order_area_compares.json",
        data: {year: params.year,
            indicator: params.indicator,
            is_real_sell_info: params.is_real_sell_info,
            topn: params.topn},
        dataType: "json",
        success: deal_resonse_json
    });
}

function deal_resonse_json(respJSON) {
    if (respJSON.status != 0) {
        alert('服务器返回错误（status = ' + respJSON.status + ", message = " + respJSON.message + ')');
        return;
    }
    params = respJSON.data.params;
    datasets = respJSON.data.datasets;
    datasets_src = respJSON.data.datasets_src;
    datasets1 = respJSON.data.datasets1;
    datasets1_src = respJSON.data.datasets1_src;

    draw_lines( {responsive: true,
        pointHitDetectionRadius: 1,
        datasetFill: false,
        pointDot: respJSON.data.pointDot} );
}

function change_dataset(key, value, desc) {
    window.pie.destroy();
    window.pie1.destroy();
    document.getElementById('table_province').innerHTML = "";
    document.getElementById('table_city').innerHTML = "";
    params[key] = value;
    $('#lbl_' + key).html(desc);
    $("ul.pie-legend").remove();
    send_data_request(params);
}

function draw_graph(canvas_id, datasets, datasets_src, graph_name, table_id, options) {
    var ctx = document.getElementById(canvas_id).getContext("2d");
    window[graph_name] = new Chart(ctx).Pie(datasets, options);

    var legendHolder = $("<div id='" + canvas_id + "_legend'>")[0];
    legendHolder.innerHTML = window[graph_name].generateLegend();
    // Include a html legend template after the module doughnut itself

    document.getElementById(canvas_id).parentNode.parentNode
        .appendChild(legendHolder.firstChild);

    var table1 = document.getElementById(table_id);
    var topn = parseInt(params.topn);
    for (var i = 0; i < datasets_src.length; i++) {
        var tr;
        if (i < topn)
            tr = $('<tr>').addClass('topn')[0];
        else
            tr = $('<tr>')[0];
        var td0 = document.createElement('td');
        td0.innerHTML = datasets_src[i].rank;
        var td1 = document.createElement('td');
        td1.innerHTML = datasets_src[i].label;
        var td2 = document.createElement('td');
        td2.innerHTML = datasets_src[i].value;
        var td3 = document.createElement('td');
        td3.innerHTML = datasets_src[i].percent;
        tr.appendChild(td0);
        tr.appendChild(td1);
        tr.appendChild(td2);
        tr.appendChild(td3);
        table1.appendChild(tr);
    }
}

function draw_lines(options) {
    console.log("draw_lines");
    draw_graph('canvas', datasets, datasets_src, 'pie', 'table_province', options);
    draw_graph('canvas1', datasets1, datasets1_src, 'pie1', 'table_city', options);
}


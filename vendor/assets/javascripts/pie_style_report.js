/**
 * Created by jjh on 12/3/14.
 */
var params = {};

function send_pie_data_request(canvas_id, graph_name, url, response_deal_fuction) {
    $.ajax({
        type: "GET",
        url: url,
        data: {year: params.year,
               indicator: params.indicator,
               is_real_sell_info: params.is_real_sell_info,
               topn: params.topn},
        dataType: "json",
        success:  function(respJSON, textStatus, jqXHR){
            if (respJSON.status != 0) {
                alert('服务器返回错误（status = ' + respJSON.status + ", message = " + respJSON.message + ')');
                return;
            }
            default_pie_response_deal_function(respJSON, canvas_id, graph_name);
            if (response_deal_fuction != undefined)
                response_deal_fuction(respJSON);
            console.log('ajax success function call done.')
        }
    });
}

function default_pie_response_deal_function(respJSON, canvas_id, graph_name) {
    params = respJSON.data.params;
    var datasets = respJSON.data.datasets;
    var options = {  responsive: true,
                     pointHitDetectionRadius: 1,
                     datasetFill: false,
                     pointDot: respJSON.data.pointDot };
    console.log('before draw pie');
    draw_pie(canvas_id, datasets, graph_name, options);
}


function draw_pie(canvas_id, datasets, graph_name, options) {
    var ctx = document.getElementById(canvas_id).getContext("2d");
    window[graph_name] = new Chart(ctx).Pie(datasets, options);

    // Include a html legend template after the module doughnut itself
    var legendHolder = $("<div id='" + canvas_id + "_legend'>")[0];
    legendHolder.innerHTML = window[graph_name].generateLegend();
    document.getElementById(canvas_id).parentNode.parentNode.appendChild(legendHolder.firstChild);

    console.log('after call draw_pie()')
}


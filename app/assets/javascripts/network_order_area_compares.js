var pie_request = null;

function change_dataset(key, value, desc) {
    window.pie.destroy();
    window.pie1.destroy();
    document.getElementById('table_province').innerHTML = "";
    document.getElementById('table_city').innerHTML = "";
    pie_request.params[key] = value;
    $('#lbl_' + key).html(desc);
    $("ul.pie-legend").remove();
    pie_request.send();
}

$(document).ready(function() {
    function response_deal_fuction(respJSON) {
        function pie_draw_table(datasets_src, table_id, topn) {
            var table1 = document.getElementById(table_id);
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

        var datasets_src = respJSON.data.datasets_src;
        var datasets1 = respJSON.data.datasets1;
        var datasets1_src = respJSON.data.datasets1_src;

        var options = {  responsive: true,
            pointHitDetectionRadius: 1,
            datasetFill: false,
            pointDot: respJSON.data.pointDot };
        pie_draw_table(datasets_src, 'table_province', this.params.topn);
        this.draw_report('canvas1', datasets1, 'pie1', options);
        pie_draw_table(datasets1_src, 'table_city', this.params.topn);
    }

    var params = {}
    params['year'] = '2014'
    params['indicator'] = 'people_count'
    params['is_real_sell_info'] = '0'
    params['topn'] = '15'
    pie_request = new PieRequest('canvas', 'pie', "/network_order_area_compares.json", response_deal_fuction)
    //send_pie_data_request('canvas', 'pie', "/network_order_area_compares.json", response_deal_fuction)
    pie_request.params = params;
    pie_request.send();
} );



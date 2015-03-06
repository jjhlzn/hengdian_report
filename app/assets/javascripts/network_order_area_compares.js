$(document).ready(function() {
    function response_deal_fuction(respJSON) {
        function pie_draw_table(id, datasets_src, topn) {
            var table_id = id+'_table';
            var table = $("<table class = 'table' id = '" + table_id + "' width='100%'>");
            for (var i = 0; i < datasets_src.length; i++) {
                var tr = $('<tr>');
                if (i < topn)
                    tr.addClass('topn');
                $('<td>').html(datasets_src[i].rank).appendTo(tr);
                $('<td>').html(datasets_src[i].label).appendTo(tr);
                $('<td>').html(datasets_src[i].value).appendTo(tr);
                $('<td>').html(datasets_src[i].percent).appendTo(tr);
                tr.appendTo(table);
            }
            table.appendTo('#'+id+" > .panel-body");
        }
        pie_draw_table(this.id, respJSON.data.datasets_src, this.params.topn);
    }

    var update_report_chart = function (key, value, desc) {
        window[this.graph_name].destroy();
        this.params[key] = value;
        $("#" + this.id + '_' + key + "_menu_item_desc").html('&nbsp;'+desc);
        $("#" + this.id + "_legend").remove();
        $('#'+this.id+'_table').remove();
        this.send_request();
    }

    var province_pie = new PieReportChart({id: 'province_pie',
        name: '省级比较',
        url: "/network_order_area_compares.json",
        menus: [{type: 'year'}, {type: 'daterange'}, {type: 'indicator'}, {type: 'topn'}],
        other_params: {type: 'province'},
        other_response_deal_function: response_deal_fuction,
        update_report_chart: update_report_chart
    }).send_request();

    var city_pie = new PieReportChart({id: 'city_pie',
        name: '地区级市比较',
        url: "/network_order_area_compares.json",
        menus: [{type: 'year'}, {type: 'daterange'}, {type: 'indicator'},  {type: 'topn'}],
        other_params: {type: 'city'},
        other_response_deal_function: response_deal_fuction,
        update_report_chart: update_report_chart
    }).send_request();
} );



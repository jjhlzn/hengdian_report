$(document).ready(function () {
    /*
    new PieReportChart({
        id: 'production_compare_pie',
        name: '门票, 酒店, 套餐比例',
        url: '/network_order_yearly_reports.json',
        menus: [{type: 'year'}, {type: 'indicator'}]
    }).send_request();*/
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
    new PieReportChart({
        id: 'mobile_corp_compare_pie',
        name: '运营商对比',
        url: '/network_order_yearly_reports/mobile_company_cmp.json',
        menus: [{type: 'year'}, {type: 'indicator'}],
        other_response_deal_function: response_deal_fuction,
        update_report_chart: update_report_chart
    }).send_request();

});


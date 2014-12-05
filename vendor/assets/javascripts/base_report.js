/**
 * Created by jjh on 12/4/14.
 */
var ReportChart = function() {};
var ReportChartView = function(){};

ReportChart.prototype = {
    params: {},
    send_request: function() {
        var that = this;
        $.ajax({
            type: "GET",
            url: this.url,
            dataType: "json",
            data: that.params,
            success:  function(respJSON, textStatus, jqXHR){
                if (respJSON.status != 0) {
                    alert('服务器返回错误（status = ' + respJSON.status + ", message = " + respJSON.message + ')');
                    return;
                }
                console.log(this.default_response_deal_function);
                that.default_response_deal_function(respJSON, that.canvas_id, that.graph_name);
                if (that.other_response_deal_function != undefined)
                    that.other_response_deal_function(respJSON);
                console.log('ajax success function call done.')
            }
        });
    },

    draw_report: function (chart_func_name, datasets, options){
        var ctx = document.getElementById(this.canvas_id).getContext("2d");
        console.log(this.canvas_id);
        console.log(this.graph_name);
        console.log(chart_func_name);
        window[this.graph_name] = new Chart(ctx)[chart_func_name](datasets, options);

        // Include a html legend template after the module doughnut itself
        //var legendHolder = $("<div id='" + this.id + "_legend'>")[0];
        //legendHolder.innerHTML = window[this.graph_name].generateLegend();
        //document.getElementById(this.canvas_id).parentNode.parentNode.appendChild(legendHolder.firstChild);
        console.log('after call draw_pie()')
    },


    initialize: function(id, name, height, width, url, other_response_deal_function) {
        var graph_name = id + "_graph";
        this.graph_name = graph_name;
        this.url = url;
        var canvas_id = id+"_canvas";
        this.id = id;
        this.canvas_id = canvas_id;
        this.other_response_deal_function  = other_response_deal_function;


        $("<div class='panel-heading'>")
            .append($("<i class='fa fa-bar-chart-o fa-fw>'>"))
            .append(' '+name)
            .append($("<div class='pull-right'>")
                        .append(this.create_indicator_menu_button())).appendTo('#'+id);
        $("<div class='panel-body'>")
            .append($("<div class='labeled-chart-container'>")
                .append($("<div class='canvas-holder'>")
                            .append("<canvas id='"+canvas_id+"' height='"+height+"' width='"+width+"'>"))).appendTo('#'+id);
    },


    create_indicator_menu_button: function() {
        return $("<div class='btn-group'>")
            .append($("<button type='button' class='btn btn-default btn-xs dropdown-toggle'"
            + " id='" + this.id + "_dropdownMenu' data-toggle='dropdown'>")
                .append("选择指标")
                .append($("<span class='caret'>")))
            .append($("<ul class='dropdown-menu' role='menu' aria-labelledby='" + this.id + "_dropdownMenu'>")
                .append(this.create_menu_item('indicator', 'people_count', '人数'))
                .append(this.create_menu_item('indicator', 'total_money', '营收'))
                .append(this.create_menu_item('indicator', 'order_count', '订单数')))
            .append($("<span id='"+ this.id + "_menu_item_desc'>").append("&nbsp;人数"));
    },

    create_menu_item: function(indicator_name, indicator_value, desc) {
        var menu_item = $("<a role='menuitem' tabindex='-1' href='#'>" + desc + "</a>");
        var that = this;
        menu_item.on('click',
                     function() {
                         that.update_report_chart(indicator_name, indicator_value, desc);
                     });
        return $("<li role='presentation'>").append(menu_item);
    },

    update_report_chart: function (key, value, desc) {
        //alert(this.id);
        //alert(this.params);
        window[this.graph_name].destroy();
        this.params[key] = value;
        $("#" + this.id + "_menu_item_desc").html(desc);
        $("#" + this.id + "_legend").remove();
        this.send_request();
    }

}

ReportChartView.prototype = {

}



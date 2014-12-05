/**
 * Created by jjh on 12/4/14.
 */
var ReportChart = function() {};

ReportChart.prototype = {
    params: {},
    send_request: function() {
        var that = this;
        $.ajax({
            type: "GET",
            url: this.url,
            dataType: "json",
            data: this.params,
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


    initialize: function(id, name, height, width, graph_name, url, other_response_deal_function) {
        this.graph_name = graph_name;
        this.url = url;
        var canvas_id = id+"_canvas";
        this.id = id;
        this.canvas_id = canvas_id;
        this.other_response_deal_function  = other_response_deal_function;


        var panel_heading = $("<div class='panel-heading'>")
                                .append($("<i class='fa fa-bar-chart-o fa-fw>'>"))
                                .append(' '+name)
                                .append($("<div class='pull-right'>")
                                            .append(this.create_button_group(this.params)));
        var panel_body = $("<div class='panel-body'>")
                                .append($("<div class='labeled-chart-container'>")
                                    .append($("<div class='canvas-holder'>")
                                                .append("<canvas id='"+canvas_id+"' height='"+height+"' width='"+width+"'>")));

        $('#'+id).append(panel_heading).append(panel_body);

    },

    create_button_group: function(params) {
        return $("<div class='btn-group'>")
                .append($("<button type='button' class='btn btn-default btn-xs dropdown-toggle'"
                        + " id='" + this.id + "_dropdownMenu' data-toggle='dropdown'>")
                    .append("选择指标")
                    .append($("<span class='caret'>")))
                .append($("<ul class='dropdown-menu' role='menu' aria-labelledby='" + this.id + "_dropdownMenu'>")
                    .append(this.create_menu_item(params,'indicator', 'people_count', '人数'))
                    .append(this.create_menu_item(params,'indicator', 'total_money', '营收'))
                    .append(this.create_menu_item(params,'indicator', 'order_count', '订单数')))
                .append($("<span id='"+ this.id + "_menu_item_desc'>").append("人数"));
    },

    create_menu_item: function(params, indicator_name, indicator_value, desc) {
        var menu_item = $("<a role='menuitem' tabindex='-1' href='#'>");
        var that = this;
        alert(this);
        menu_item.on('click',
                     function() {
                         alert(that);
                         that.update_report_chart(params, indicator_name, indicator_value, desc);
                     });
        return $("<li role='presentation'>").append(menu_item).append(desc);
    },

    update_report_chart: function (params, key, value, desc) {
        alert(this.id);
        alert(params);
        window[this.graph_name].destroy();
        params[key] = value;
        $("#" + this.id + "_menu_item_desc").html(desc);
        $("#" + this.id + "_legend").remove();
        this.send();
    }

}



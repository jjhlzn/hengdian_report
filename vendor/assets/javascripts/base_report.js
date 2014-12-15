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
        var legendHolder = $("<div id='" + this.id + "_legend'>")[0];
        legendHolder.innerHTML = window[this.graph_name].generateLegend();
        document.getElementById(this.canvas_id).parentNode.parentNode.appendChild(legendHolder);
        console.log('after call draw_pie()')
    },


    //initialize: function(id, name, height, width, url, other_response_deal_function) {
    initialize: function(spec) {
        this.params = spec.other_params || {};
        var graph_name = spec.id + "_graph";
        this.graph_name = graph_name;
        this.url = spec.url;
        var canvas_id = spec.id+"_canvas";
        this.id = spec.id;
        this.canvas_id = canvas_id;
        this.other_response_deal_function  = spec.other_response_deal_function;
        var height = spec.height || 200;
        var width = spec.width || 400;
        this.height = height;
        this.width = width;
        spec.name = spec.name || '';
        var menus = spec.menus || [{type: 'indicator'}];

        var update_report_chart = function (key, value, desc) {
            window[this.graph_name].destroy();
            this.params[key] = value;
            $("#" + this.id + '_' + key + "_menu_item_desc").html('&nbsp;'+desc);
            $("#" + this.id + "_legend").remove();
            this.send_request();
        }
        this.update_report_chart = spec.update_report_chart || update_report_chart;

        var menu_buttons = this.create_menu_buttons(menus);
        var div_pull_right = $("<div class='pull-right'>");
        var i;
        if (menu_buttons.length > 0){
            for (i = 0; i < menu_buttons.length; i++)
                div_pull_right.append(menu_buttons[i]).append('&nbsp;&nbsp;&nbsp;');
                ;
        }

        $("<div class='panel-heading'>")
            .append($("<i class='fa fa-bar-chart-o fa-fw>'>"))
            .append(' '+spec.name)
            .append(div_pull_right).appendTo('#'+spec.id);
        $("<div class='panel-body'>")
            .append($("<div class='labeled-chart-container'>")
                .append($("<div class='canvas-holder'>")
                            .append("<canvas id='"+canvas_id+"' height='"+height+"' width='"+width+"'>"))).appendTo('#'+spec.id);
    },

    create_menu_buttons: function(param_menus){
        var create_year_menu_button = function(name, desc, items) {
            name = name || 'year';
            desc = desc || '选择年份';
            items = items || [{value: '2014', desc: '2014'},
                              {value: '2013', desc: '2013'}];
            return this.create_menu_button(name, desc, items);
        };

        var create_indicator_menu_button = function(name, desc, items) {
            name = name || 'indicator'
            desc = desc || '选择指标'
            items = items || [{value: 'total_money', desc: '营收'},
                        {value: 'people_count', desc: '人数'},
                      {value: 'order_count', desc: '订单数'}];
            return this.create_menu_button(name, desc, items);
        };

        var create_topn_menu_button = function(name, desc, items) {
            name = name || 'topn'
            desc = desc || '选择前N位'
            items = [{value: '5', desc: '5'},
                {value: '10', desc: '10'},
                {value: '15', desc: '15'},
                {value: '20', desc: '20'}];
            return this.create_menu_button(name, desc, items);
        };

        var create_yesorno_menu_button = function(name, desc, items) {
            name = name || 'yesorno'
            console.log('desc = '+ desc);
            desc = desc || '--选择是或否'
            items = [{value: '1', desc: '是'},
                {value: '0', desc: '否'}]
            return this.create_menu_button(name, desc, items)
         }

        var menu_mappings = [{type: 'indicator', func: create_indicator_menu_button},
            {type: 'year', func: create_year_menu_button},
            {type: 'topn', func: create_topn_menu_button},
            {type: 'yesorno', func: create_yesorno_menu_button}];

        var get_menu_func = function(type) {
            var i;
            for (i = 0; i < menu_mappings.length; i++)
                if (type === menu_mappings[i]['type'])
                    return menu_mappings[i]['func'];
        }

        var menu_buttons = [];
        var i;
        for (i = 0; i < param_menus.length; i++) {
            var func;
            if (func = get_menu_func(param_menus[i]['type']))
                menu_buttons.push(func.apply(this, [param_menus[i].name, param_menus[i].desc, param_menus[i].items]));
        }

        return menu_buttons;
    },

    create_menu_button: function(param_name, desc, items) {
        this.params[param_name] = items[0]['value'];
        var menu_id  = this.id + '_' + param_name + '_dropdownmenu';
        var dropdown_menu =  $("<ul class='dropdown-menu' role='menu' aria-labelledby='" + menu_id + "'>");
        var i;
        for (i = 0; i < items.length; i++)
            dropdown_menu.append(this.create_menu_item(param_name, items[i]['value'], items[i]['desc']));
        return $("<div class='btn-group'>")
            .append($("<button type='button' class='btn btn-default btn-xs dropdown-toggle'"
            + " id='" + menu_id + "' data-toggle='dropdown'>")
                .append(desc)
                .append($("<span class='caret'>")))
            .append(dropdown_menu)
            .append($("<span id='"+ this.id + '_' + param_name + "_menu_item_desc'>").append("&nbsp;"+items[0]['desc']));
    },

    create_menu_item: function(indicator_name, indicator_value, desc) {
        var menu_item = $("<a role='menuitem' tabindex='-1' href='#'>" + desc + "</a>");
        var that = this;
        menu_item.on('click',
                     function() {
                         that.update_report_chart(indicator_name, indicator_value, desc);
                     });
        return $("<li role='presentation'>").append(menu_item);
    }



}

ReportChartView.prototype = {

}



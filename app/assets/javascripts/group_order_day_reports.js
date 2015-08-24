$(document).ready(function () {

    new LineReportChart({
        id: 'line_panel',
        name: '最近30天订单情况(已使用订单)',
        url: '/group_order_day_reports/latest_30days_report.json',
        menus: [{type: 'indicator'}]
    }).send_request();

    new LineReportChart({
        id: 'reserve_line_panel',
        name: '最近预订情况(包括使用订单和未使用订单)',
        url: '/group_order_day_reports/reserve.json',
        menus: [{type: 'datetype'}, {type: 'indicator'}]
    }).send_request();

});


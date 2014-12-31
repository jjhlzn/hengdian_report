$(document).ready(function () {
    new PieReportChart({
        id: 'pie_panel',
        name: '门票, 酒店, 套餐比例',
        url: '/network_order_today_reports.json'
    }).send_request()

    new LineReportChart({
        id: 'line_panel',
        name: '最近30天订单情况(已使用订单)',
        url: '/network_order_report/latest_30days_report.json'
    }).send_request();

    new LineReportChart({
        id: 'reserve_line_panel',
        name: '最近预订情况(包括使用订单和未使用订单)',
        url: '/network_order_today_reports/reserve.json',
        menus: [{type: 'datetype'}, {type: 'indicator'}]
    }).send_request();
});


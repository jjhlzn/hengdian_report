$(document).ready(function () {
    new PieReportChart({
        id: 'pie_panel',
        name: '门票, 酒店, 套餐比例(当天)',
        url: '/network_order_today_reports.json',
        menus: [{type: 'datetype'}, {type: 'indicator'}]
    }).send_request()

    new LineReportChart({
        id: 'line_panel',
        name: '最近30天订单情况(已使用订单)',
        url: '/network_order_report/latest_30days_report.json',
        menus: [{type: 'indicator'}]
    }).send_request();

    new LineReportChart({
        id: 'reserve_line_panel',
        name: '最近预订情况(包括使用订单和未使用订单)',
        url: '/network_order_today_reports/reserve.json',
        menus: [{type: 'datetype'}, {type: 'indicator'}]
    }).send_request();

    new LineReportChart({
        id: 'official_line_panel',
        name: '官网预订情况(包括使用订单和未使用订单)',
        url: '/network_order_today_reports/official.json',
        menus: [{type: 'datetype'}, {type: 'indicator'}]
    }).send_request();

    new LineReportChart({
        id: 'official_website_line_panel',
        name: '官网网站预订情况对比(包括使用订单和未使用订单)',
        url: '/network_order_today_reports/official_website.json',
        menus: [{type: 'datetype'}, {type: 'indicator'}]
    }).send_request();

    new LineReportChart({
        id: 'official_taobao_line_panel',
        name: '淘宝预订情况对比(包括使用订单和未使用订单)',
        url: '/network_order_today_reports/official_taobao.json',
        menus: [{type: 'datetype'}, {type: 'indicator'}]
    }).send_request();
});

